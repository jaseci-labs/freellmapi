# Observed tool-calling rejections (#1230). models.supports_tools is only a
# declaration, so a relay model that rejects every request carrying `tools`
# would be walked again on each one. This remembers the rejections in memory,
# per model and endpoint, and lets the router try such a model last for tool
# requests: a preference, never a filter, and nothing is written to the DB.
glob TOOL_REJECTION_LIMIT: int = 3,
     TOOL_REJECTION_WINDOW_MS: int = 60 * 60 * 1000,
     TOOL_BENCH_MS: int = 6 * 60 * 60 * 1000;

glob:priv rejections: dict[str, list[float]] = {},
          benchedUntil: dict[str, float] = {};

def toolCapabilityKey(platform: str, modelId: str, endpointScope: any = None) -> str {
    return modelStatsKey(platform, modelId, endpointScope);
}

def benchForTools(key: str, now: any = None) {
    at: float = now ?? globalThis.Date.now();
    already = benchedUntil.get(key, 0) > at;
    benchedUntil[key] = at + TOOL_BENCH_MS;
    rejections.pop(key, None);
    if not already {
        globalThis.console.warn(
            f"[ToolCapability] {key} keeps rejecting tool-calling requests; trying it last for tool requests for {TOOL_BENCH_MS // 3600000}h",
        );
    }
}

# Three distinct requests must be rejected before the model is deferred.
def noteToolRejection(key: str, now: any = None) {
    at: float = now ?? globalThis.Date.now();
    recent = [t for t in rejections.get(key, []) if at - t < TOOL_REJECTION_WINDOW_MS] + [at];
    if len(recent) >= TOOL_REJECTION_LIMIT {
        benchForTools(key, at);
    } else {
        rejections[key] = recent;
    }
}

def clearToolRejections(key: str) {
    rejections.pop(key, None);
    benchedUntil.pop(key, None);
}

def isToolBenched(platform: str, modelId: str, endpointScope: any = None, now: any = None) -> bool {
    key = toolCapabilityKey(platform, modelId, endpointScope);
    if benchedUntil.get(key, 0) > (now ?? globalThis.Date.now()) {
        return True;
    }
    benchedUntil.pop(key, None);
    return False;
}

def resetToolCapability {
    rejections.clear();
    benchedUntil.clear();
}
