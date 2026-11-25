# Per-key model scope (#657): api_keys.model_scope_json is an optional JSON
# array of model ids, and a scoped key serves no model outside it. An empty or
# corrupt value is unscoped (null), so that it never benches the key.
def parseModelScope(json: any = None) -> any {
    try {
        raw: any = globalThis.JSON.parse(json or "null");
        ids = [v for v in raw if isinstance(v, str) and v] if globalThis.Array.isArray(raw) else [];
        return new(globalThis.Set, ids) if ids else NULL;
    } except Exception {
        return NULL;
    }
}

def scopeAllows(scope: any, modelId: str) -> bool {
    return scope is NULL or scope.has(modelId);
}
