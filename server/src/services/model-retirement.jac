# Auto-retirement of models the upstream has removed (#634): NVIDIA answered
# every request for one model with "410 ... end of life", and a model-level
# skip only rules a model out for one request. A definitive end-of-life
# disables the model at once; a probable one waits for a second distinct
# request within the hour, so one flaky 404 cannot kill a healthy model. The
# user can switch it back on, and a catalog refresh that still lists it lifts
# the retirement.
type RetirementRoute = any;

glob RETIREMENT_CONFIRMATIONS_REQUIRED: int = 2,
     RETIREMENT_OBSERVATION_WINDOW_MS: int = 60 * 60 * 1000;

# Per model and endpoint: (count, first seen, last request token). Process
# local, deliberately.
glob:priv observations: dict[str, list[any]] = {};

def resetModelRetirementObservations {
    observations.clear();
}

# True once enough distinct requests reported it gone. One request failing
# over across sibling keys is one request's evidence.
def:priv confirmObservation(key: str, requestToken: any) -> bool {
    now = globalThis.Date.now();
    seen = observations.get(key);
    if seen is None or now - seen[1] > RETIREMENT_OBSERVATION_WINDOW_MS {
        observations[key] = [1, now, requestToken];
        return RETIREMENT_CONFIRMATIONS_REQUIRED <= 1;
    }
    if requestToken is not None and seen[2] is requestToken {
        return False;
    }
    (seen[0], seen[2]) = (seen[0] + 1, requestToken);
    return seen[0] >= RETIREMENT_CONFIRMATIONS_REQUIRED;
}

# True when this call retired the model. Never throws: it runs on the proxy's
# failure path. Only catalog-managed rows: one the user added is theirs.
def noteModelRetirementSignal(route: any, err: any = None, requestToken: any = None) -> bool {
    confidence: any = modelRetirementSignal(err);
    key = modelStatsKey(route.platform, route.modelId, getattr(route, "endpointScope", None));
    if not confidence or (confidence == "probable" and not confirmObservation(key, requestToken)) {
        return False;
    }
    reason = summarizeAttemptError(getattr(err, "message", None) if err else None);
    try {
        db: any = getDb();
        row: any = db.prepare(
            "SELECT id, platform, model_id, key_id, source FROM models WHERE id = ?"
        ).get(route.modelDbId);
        if not row
            or not isCatalogManagedModel(row)
            or not retireCatalogModelUpstream(db, row.id, row.platform, row.model_id, reason)
        {
            return False;
        }
        observations.pop(key, None);
        providerLog(
            "warn",
            f"[ModelRetirement] {row.platform}/{row.model_id} disabled — upstream reports it retired: {reason}",
            plain(provider=row.platform, model=row.model_id, event="model_retired"),
        );
        return True;
    } except Exception as e {
        globalThis.console.warn(
            f"[ModelRetirement] could not record retirement for {key}: {e?.message or e}",
        );
        return False;
    }
}
