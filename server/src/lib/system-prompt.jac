import from "crypto" { default as crypto }

# Per-client API keys with server-enforced system prompts (#411). A client
# profile key authenticates only the /v1 inference surface, never /api; the
# unified key keeps full access and no injected prompt.
type ResolvedAuth = any;

glob CLIENT_PROFILE_KEY_PREFIX: str = "sk-cp-";

# HMAC both sides to fixed-length digests, so the comparison leaks neither a
# per-character timing nor the length.
def timingSafeStringEqual(provided: str, expected: str) -> bool {
    key = globalThis.Buffer.alloc(32);
    def digest(text: str) -> any {
        return crypto.createHmac("sha256", key).update(text).digest();
    }
    return crypto.timingSafeEqual(digest(provided), digest(expected));
}

def mintClientProfileKey -> str {
    return CLIENT_PROFILE_KEY_PREFIX + crypto.randomBytes(24).toString("hex");
}

# Keys are looked up by SHA-256 digest, so the DB holds no plaintext for auth
# and the indexed lookup is independent of the secret's bytes.
def hashClientProfileKey(key: str) -> str {
    return crypto.createHash("sha256").update(key).digest("hex");
}

# A disabled profile is refused as an unknown key is, so a revoked client
# cannot tell "disabled" from "deleted".
def resolveAuth(token: any = None) -> any {
    if not token {
        return NULL;
    }
    if timingSafeStringEqual(token, getUnifiedApiKey()) {
        return plain(kind="unified", systemPrompt=NULL);
    }
    if not token.startswith(CLIENT_PROFILE_KEY_PREFIX) {
        return NULL;
    }
    row: any = getDb().prepare(
        "SELECT id, name, system_prompt, enabled FROM client_profiles WHERE token_hash = ?"
    ).get(hashClientProfileKey(token));
    if not row or not row.enabled {
        return NULL;
    }
    prompt: any = row.system_prompt if row.system_prompt and row.system_prompt.strip() else NULL;
    return plain(kind="profile", profileId=row.id, name=row.name, systemPrompt=prompt);
}

# The enforced prompt goes first, ahead of the caller's own system message,
# which it keeps: the caller may add context but not override it.
def prependSystemPrompt(messages: any, prompt: any = None) -> any {
    if missing(prompt) or not prompt.strip() {
        return messages;
    }
    return [plain(role="system", content=prompt), *messages];
}
