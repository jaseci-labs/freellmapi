# One row of request analytics, written alike by every inference surface and
# fusion's sub-calls. Status is 'success', 'error' or 'canceled' (#752): a
# canceled request counts toward totals but toward neither rate. The same
# transaction updates request_hourly and the lifetime totals in settings, so
# the analytics survive the raw rows' prune and never disagree with them.
glob:priv INSERT_REQUEST: str = "INSERT INTO requests (platform, model_id, key_id, status, input_tokens, output_tokens, latency_ms, error, ttfb_ms, requested_model, served_model, client_ip, client_user_agent, client_agent, caller, model_db_id, failure_attribution) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          UPSERT_HOUR: str = "INSERT INTO request_hourly (hour, total_requests, success_count, error_count, input_tokens, output_tokens) VALUES (?, 1, ?, ?, ?, ?) ON CONFLICT(hour) DO UPDATE SET total_requests = total_requests + 1, success_count = success_count + ?, error_count = error_count + ?, input_tokens = input_tokens + ?, output_tokens = output_tokens + ?",
          INCREMENT: str = "INSERT INTO settings (key, value) VALUES (?, ?) ON CONFLICT(key) DO UPDATE SET value = CAST(CAST(value AS INTEGER) + ? AS TEXT)",
          INSERT_ATTEMPT: str = "INSERT INTO request_attempts (request_id, ordinal, platform, model_id, key_ordinal, key_label, outcome, start_offset_ms, duration_ms, error_summary) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

def:priv orNull(value: any) -> any {
    return NULL if missing(value) else value;
}

# The models.id a request is attributed to (#1187): a catalog request by
# (platform, model_id), a custom one through its key's endpoint. Null where it
# cannot be told, rather than the wrong relay.
def:priv resolveModelDbId(db: any, platform: str, modelId: str, keyId: any) -> any {
    if platform != "custom" {
        row: any = db.prepare(
            "SELECT id FROM models WHERE platform = ? AND model_id = ? LIMIT 1"
        ).get(platform, modelId);
        return row.id if row else NULL;
    }
    key: any = db.prepare("SELECT base_url FROM api_keys WHERE id = ? AND platform = 'custom'").get(
        keyId
    )
        if not missing(keyId)
        else None;
    if not key or not key.base_url {
        return NULL;
    }
    row = db.prepare(
        "SELECT id FROM models WHERE platform = ? AND model_id = ? AND endpoint_scope = ? LIMIT 1"
    ).get("custom", modelId, sub(key.base_url.trim(), "\\/+$", ""));
    return row.id if row else NULL;
}

# keyId is null for a request turned away before routing. servedModel is set
# only where the upstream served another model (#534); caller names the
# pathway ('http'); failureAttribution is 'provider_moment' where a failure is
# put on the provider's minute (#1347).
def logRequest(
    platform: str,
    modelId: str,
    keyId: any,
    status: str,
    inputTokens: float,
    outputTokens: float,
    latencyMs: float,
    error: any,
    ttfbMs: any = None,
    requestedModel: any = None,
    servedModel: any = None,
    caller: any = None,
    failureAttribution: any = None,
) -> bool {
    try {
        db: any = getDb();
        client: any = getClientContext();
        def write {
            inserted: any = db.prepare(INSERT_REQUEST).run(
                platform,
                modelId,
                orNull(keyId),
                status,
                inputTokens,
                outputTokens,
                latencyMs,
                orNull(error),
                orNull(ttfbMs),
                orNull(requestedModel),
                orNull(servedModel),
                client.ip,
                client.userAgent,
                client.agent,
                orNull(caller),
                resolveModelDbId(db, platform, modelId, keyId),
                orNull(failureAttribution),
            );
            # The fallback loop keys its attempt trace to the last row noted.
            if not missing(inserted.lastInsertRowid) {
                noteRequestRowId(inserted.lastInsertRowid);
            }
            row: any = db.prepare("SELECT created_at FROM requests WHERE id = ?").get(
                inserted.lastInsertRowid
            );
            createdAt: any = row.created_at if row else None;
            hour = (createdAt or new(globalThis.Date).toISOString()[:19].replace("T", " "))[:13]
                + ":00:00";
            (ok, failed) = (int(status == "success"), int(status == "error"));
            db.prepare(UPSERT_HOUR).run(
                hour, ok, failed, inputTokens, outputTokens, ok, failed, inputTokens, outputTokens
            );
            for (key, delta) in [
                ("total_requests", 1),
                ("total_input_tokens", inputTokens),
                ("total_output_tokens", outputTokens),
            ] {
                db.prepare(INCREMENT).run(key, globalThis.String(delta), delta);
            }
            if createdAt {
                db.prepare(
                    "INSERT INTO settings (key, value) VALUES (?, ?) ON CONFLICT(key) DO NOTHING"
                ).run("first_request_at", createdAt);
            }
        }
        db.transaction(write)();
        pruneRequestAnalytics(plain(db=db));
        # Soft budget alerts (#1158), once the ledger trigger has committed.
        if status == "success" and not missing(keyId) {
            noteBudgetAlerts(keyId);
        }
        return True;
    } except Exception as e {
        globalThis.console.error("Failed to log request:", e);
        return False;
    }
}

# A finished attempt trace, as one batch keyed to the ladder's terminal row,
# written after the response is done. A trace with no parent row writes
# nothing: its failed attempts each wrote their own row already.
def persistRequestAttempts(trace: any) {
    if trace.records.length == 0 or missing(trace.lastRequestRowId) {
        return;
    }
    try {
        db: any = getDb();
        insert: any = db.prepare(INSERT_ATTEMPT);
        def write {
            for r in trace.records {
                insert.run(
                    trace.lastRequestRowId,
                    r.ordinal,
                    r.platform,
                    r.modelId,
                    r.keyOrdinal,
                    r.keyLabel,
                    r.outcome,
                    r.startOffsetMs,
                    r.durationMs,
                    r.errorSummary,
                );
            }
        }
        db.transaction(write)();
    } except Exception as e {
        globalThis.console.error("Failed to persist request attempts:", e);
    }
}
