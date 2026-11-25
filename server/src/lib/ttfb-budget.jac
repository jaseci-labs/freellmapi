import from "node:process" { default as process }

# Gives a historically slow endpoint its decay-weighted P95 time to first
# byte, plus a buffer, as its patience. Fewer than five in-window successes
# is an anecdote. Logged TTFB includes the hops that failed first, so a wider
# budget would ratchet itself up: it is capped at three times the operator's
# budget. And only a P95 at least half that budget counts as slow, since the
# buffer is absolute.
type EndpointTtfbStats = any;

glob:priv DAY_MS: int = 24 * 60 * 60 * 1000,
          OFFSET: any = rx("(?:Z|[+-]\\d{2}:?\\d{2})$", "i"),
          cache: any = None;

def invalidateTtfbBudgetCache {
    cache = None;
}

def:priv duration(
    settings: dict[str, any], key: str, fallback: float, allowZero: bool = False
) -> float {
    for raw in [settings.get(key), process.env[key.upper()]] {
        value: any = globalThis.Number(raw) if isinstance(raw, str) and raw.strip() else -1;
        if globalThis.Number.isFinite(value) and (value >= 0 if allowZero else value > 0) {
            return value;
        }
    }
    return fallback;
}

# Read per attempt, so a loop and module functions: a comprehension and a
# nested def are each made anew on every call.
def:priv readConfig(db: any) -> dict[str, float] {
    settings: dict[str, any] = {};
    for row in db.prepare(
        "SELECT key, value FROM settings WHERE key IN ('slow_endpoint_buffer_ms', 'ttfb_budget_window_ms', 'ttfb_budget_half_life_ms', 'ttfb_budget_min_samples')",
    ).all() {
        settings[row.key] = row.value;
    }
    return {
        "bufferMs": duration(settings, "slow_endpoint_buffer_ms", 10000, True),
        "windowMs": duration(settings, "ttfb_budget_window_ms", 7 * DAY_MS),
        "halfLifeMs": duration(settings, "ttfb_budget_half_life_ms", 2 * DAY_MS),
        "minSamples": duration(settings, "ttfb_budget_min_samples", 5),
    };
}

# Custom relays share a platform, so never one another's latency history.
def:priv endpointKey(platform: str, endpointScope: any) -> str {
    return globalThis.JSON.stringify([
        platform,
        endpointScopeForBaseUrl(endpointScope) if platform == "custom" else "",
    ]);
}

# SQLite's datetime('now') is UTC with no suffix, which Date.parse would read
# as local time.
def:priv timestampMs(raw: str) -> float {
    iso = raw.strip().replace(" ", "T", 1);
    return globalThis.Date.parse(iso if OFFSET.test(iso) else iso + "Z");
}

def:priv percentile(samples: list[tuple[float, float]], total: float, quantile: float) -> float {
    cumulative = 0.0;
    for (ttfb, weight) in samples {
        cumulative += weight;
        if cumulative >= total * quantile {
            return ttfb;
        }
    }
    return samples[-1][0];
}

def:priv statsFor(db: any, config: dict[str, float], now: float) -> dict[str, any] {
    if cache
        and cache["db"] is db
        and cache["windowMs"] == config["windowMs"]
        and cache["halfLifeMs"] == config["halfLifeMs"]
        and 0 <= now - cache["time"] < 60000
    {
        return cache["stats"];
    }
    # A day more than the window, for timestamps with an offset; the exact
    # window is applied once every timestamp is read as UTC.
    earliest: any = new(globalThis.Date, now - config["windowMs"] - DAY_MS);
    since: str = earliest.toISOString()[:10]
        if globalThis.Number.isFinite(earliest.getTime())
        else "";
    buckets: dict[str, list[tuple[float, float]]] = {};
    for row in db.prepare(
        "SELECT r.platform, r.ttfb_ms, r.created_at, k.base_url FROM requests r LEFT JOIN api_keys k ON k.id = r.key_id AND k.platform = 'custom' WHERE r.created_at >= ? AND r.status = 'success' AND r.ttfb_ms IS NOT NULL",
    ).all(since) {
        if not isinstance(row.created_at, str)
            or not globalThis.Number.isFinite(row.ttfb_ms)
            or row.ttfb_ms < 0
        {
            continue;
        }
        age = now - timestampMs(row.created_at);
        if globalThis.Number.isFinite(age) and 0 <= age <= config["windowMs"] {
            weight = 0.5 ** (age / config["halfLifeMs"]);
            if weight > 0 {
                buckets.setdefault(endpointKey(row.platform, row.base_url or ""), []).append((
                    row.ttfb_ms,
                    weight,
                ));
            }
        }
    }
    stats: dict[str, any] = {};
    for (key, samples) in buckets.items() {
        samples.sort(key=lambda (s: tuple[float, float]) -> float { s[0] });
        total = sum(w for (_, w) in samples);
        stats[key] = {
            "p50Ms": percentile(samples, total, 0.5),
            "p95Ms": percentile(samples, total, 0.95),
            "sampleCount": len(samples),
            "weightedSamples": total,
        };
    }
    cache = {
        "db": db,
        "time": now,
        "windowMs": config["windowMs"],
        "halfLifeMs": config["halfLifeMs"],
        "stats": stats,
    };
    return stats;
}

def getEndpointTtfbStats(platform: str, endpointScope: str = "", now: any = None) -> any {
    at: float = now ?? globalThis.Date.now();
    if not globalThis.Number.isFinite(at) {
        return NULL;
    }
    try {
        db: any = getDb();
        found: any = statsFor(db, readConfig(db), at).get(endpointKey(platform, endpointScope));
        return plain(**found) if found else NULL;
    } except Exception {
        invalidateTtfbBudgetCache();
        return NULL;
    }
}

# A missing or locked DB never breaks the proxy: the base budget stands.
def getEndpointTimeBudgetMs(
    baseBudgetMs: float, platform: str, endpointScope: str = "", now: any = None
) -> float {
    at: float = now ?? globalThis.Date.now();
    if not globalThis.Number.isFinite(baseBudgetMs)
        or baseBudgetMs <= 0
        or not globalThis.Number.isFinite(at)
        or (process.env.TTFB_BUDGET_DISABLED ?? "").strip() == "1"
    {
        return baseBudgetMs;
    }
    try {
        db: any = getDb();
        config = readConfig(db);
        found: any = statsFor(db, config, at).get(endpointKey(platform, endpointScope));
    } except Exception {
        invalidateTtfbBudgetCache();
        return baseBudgetMs;
    }
    if not found
        or found["p95Ms"] <= 0
        or found["sampleCount"] < config["minSamples"]
        or found["p95Ms"] < baseBudgetMs * 0.5
    {
        return baseBudgetMs;
    }
    adaptive = float(found["p95Ms"]) + float(config["bufferMs"]);
    return max(baseBudgetMs, min(adaptive, baseBudgetMs * 3))
        if globalThis.Number.isFinite(adaptive)
        else baseBudgetMs;
}
