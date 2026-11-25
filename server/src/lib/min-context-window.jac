# The routing pool's context-window floor (#1442): one setting that excludes
# small-window models, since the smallest free tiers fail agent workloads
# before any rate limit does. Read on every call, so a dashboard change needs
# no restart, and a garbage value disables the gate rather than empty the pool.
glob MIN_CONTEXT_WINDOW_SETTING: str = "min_context_window",
     # '1m' is the 1,048,576 the largest catalog rows advertise.
     MIN_CONTEXT_WINDOW_PRESETS: any = globalThis.Object.fromEntries([
         ("32k", 32768),
         ("128k", 131072),
         ("512k", 524288),
         ("1m", 1048576),
     ]);

glob:priv NULL: any = globalThis.JSON.parse("null");

# The floor in tokens, or null when it is off, unset or the DB is not ready.
def minContextWindowFloor -> any {
    try {
        value: any = (getSetting(MIN_CONTEXT_WINDOW_SETTING) or "").trim().toLowerCase();
    } except Exception {
        return NULL;
    }
    if not value or value == "off" or value == "0" {
        return NULL;
    }
    n: any = MIN_CONTEXT_WINDOW_PRESETS[value] ?? globalThis.Number(value);
    return n if globalThis.Number.isInteger(n) and n > 0 else NULL;
}

# A model whose window is unknown always passes, as in fitsContextWindow.
def passesContextWindowFloor(contextWindow: any = None) -> bool {
    floor: any = minContextWindowFloor();
    return floor is NULL
        or contextWindow is None
        or contextWindow is NULL
        or contextWindow >= floor;
}
