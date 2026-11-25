# Scrubs secrets and URLs from a provider's error text before it is stored or
# shown. The quoted-key pattern is quote-tolerant so that JSON bodies are
# caught, and a bare run of 32+ alphanumerics is taken for a credential.
glob:priv REDACTIONS: list[any] = [
    (rx(r"\bBearer\s+[A-Za-z0-9._~+/-]+=*", "gi"), "Bearer [redacted]"),
    (
        rx(
            r"([\x22']?)\b(api[_-]?key|access[_-]?token|token|secret|authorization)\b\1(\s*[:=]\s*)([\x22']?)[^\x22',\s}\]]+",
            "gi",
        ),
        "$1$2$1$3$4[redacted]",
    ),
    (rx(r"\bsk-[A-Za-z0-9_-]{8,}\b"), "[redacted-key]"),
    (rx(r"\bgsk_[A-Za-z0-9_-]{8,}\b"), "[redacted-key]"),
    (rx(r"\bfreellmapi-[A-Za-z0-9_-]{8,}\b"), "[redacted-key]"),
    (rx(r"\bAIza[0-9A-Za-z_-]{20,}\b"), "[redacted-key]"),
    (rx(r"\b[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}\b"), "[redacted-token]"),
    (rx(r"\b[A-Za-z0-9]{32,}\b"), "[redacted-token]"),
    (rx(r"\bhttps?:\/\/[^\s\x22'<>)]*", "gi"), "[redacted-url]"),
    (rx(r"\s+"), " "),
];

def:priv rx(pattern: str, flags: str = "g") -> any {
    return new(globalThis.RegExp, pattern, flags);
}

def:priv capped(text: any, limit: int) -> str {
    return text if text.length <= limit else text.slice(0, limit - 3).trimEnd() + "...";
}

def sanitizeProviderErrorMessage(message: any = None) -> str {
    text: any = globalThis.String(message ?? "").trim();
    if not text {
        return "Provider error";
    }
    for (pattern, replacement) in REDACTIONS {
        text = globalThis.String.prototype.replace.call(text, pattern, replacement);
    }
    return capped(text.trim(), 240);
}

# One line per failover attempt, for request_attempts.error_summary.
def summarizeAttemptError(message: any = None) -> str {
    return capped(sanitizeProviderErrorMessage(message), 200);
}
