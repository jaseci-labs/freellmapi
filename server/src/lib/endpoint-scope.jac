# Endpoint identity for custom relay models (#651). Every relay is platform
# 'custom', so two relays offering one model id used to share one models row
# and one stats bucket (#619). models.endpoint_scope tells them apart: the
# normalized base_url of the row's endpoint, '' for every catalog platform.
# It is the base_url, not the key, since an endpoint holds a pool of keys
# (#640), and a text token, so that #657's model groups can refine it.
glob ENDPOINT_ID_SEPARATOR: str = "#";

def normalizeBaseUrl(raw: str) -> str {
    return sub(raw.strip(), "\\/+$", "");
}

def endpointScopeForBaseUrl(baseUrl: any = None) -> str {
    return normalizeBaseUrl(baseUrl) if baseUrl else "";
}

# '' when the key is gone or has no base_url, as legacy rows always had.
def endpointScopeOfKey(db: any, keyId: any = None) -> str {
    if keyId is None or keyId is NULL {
        return "";
    }
    row: any = db.prepare("SELECT base_url FROM api_keys WHERE id = ? AND platform = 'custom'").get(
        keyId
    );
    return endpointScopeForBaseUrl(row.base_url if row else None);
}

# A stable, typable slug of a scope: https://relay-a.example.com/v1 is
# relay-a.example.com-v1.
def endpointHandle(scope: str) -> str {
    slug = sub(scope, "^[a-z][a-z0-9+.-]*:\\/\\/", "", "i").lower();
    slug = sub(sub(slug, "[^a-z0-9.]+", "-", "g"), "-+", "-", "g");
    return sub(slug, "^[-.]+|[-.]+$", "", "g") or "endpoint";
}

# Stats and round-robin bucket: platform:model_id, qualified only by a scope.
def modelStatsKey(platform: str, modelId: str, endpointScope: any = None) -> str {
    return f"{platform}:{modelId}@{endpointScope}" if endpointScope else f"{platform}:{modelId}";
}

# The id that pins one relay's copy, custom:deepseek-v3.1#relay-a.example.com-v1.
def qualifiedModelMemberId(platform: str, modelId: str, endpointScope: any = None) -> any {
    return f"{platform}:{modelId}{ENDPOINT_ID_SEPARATOR}{endpointHandle(endpointScope)}"
        if endpointScope
        else NULL;
}

# Slugging both sides makes a handle and the pasted base_url equivalent.
def endpointRefMatches(requested: str, endpointScope: str) -> bool {
    ref = requested.strip();
    return bool(ref and endpointScope) and endpointHandle(ref) == endpointHandle(endpointScope);
}

# An endpoint group's handle (#1176): `My Relays` is `my-relays`.
def groupHandle(label: str) -> str {
    return endpointHandle(label);
}

def groupRefMatches(requested: str, groupLabel: any = None) -> bool {
    return endpointRefMatches(requested, groupLabel or "");
}
