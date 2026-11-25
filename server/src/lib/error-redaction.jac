# Scrubs secrets and URLs from a provider's error text before it is stored or
# shown. The quoted-key pattern is quote-tolerant so that JSON bodies are
# caught, and a bare run of 32+ alphanumerics is taken for a credential.
glob:priv REDACTIONS: list[tuple[any, str]] = [
    (rx(r"\bBearer\s+[A-Za-z0-9._~+/-]+=*", "gi"), "Bearer [redacted]"),
    (
        rx(
            r"([\x22']?)\b(api[_-]?key|access[_-]?token|token|secret|authorization)\b\1(\s*[:=]\s*)([\x22']?)[^\x22',\s}\]]+",
            "gi",
        ),
        "$1$2$1$3$4[redacted]",
    ),
    (rx(r"\bsk-[A-Za-z0-9_-]{8,}\b", "g"), "[redacted-key]"),
    (rx(r"\bgsk_[A-Za-z0-9_-]{8,}\b", "g"), "[redacted-key]"),
    (rx(r"\bfreellmapi-[A-Za-z0-9_-]{8,}\b", "g"), "[redacted-key]"),
    (rx(r"\bAIza[0-9A-Za-z_-]{20,}\b", "g"), "[redacted-key]"),
    (
        rx(r"\b[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}\b", "g"),
        "[redacted-token]",
    ),
    (rx(r"\b[A-Za-z0-9]{32,}\b", "g"), "[redacted-token]"),
    (rx(r"\bhttps?:\/\/[^\s\x22'<>)]*", "gi"), "[redacted-url]"),
    (rx(r"\s+", "g"), " "),
];

# String.prototype's methods, called directly: on a value typed any, text.trim()
# is a dynamic call through the runtime.
def:priv capped(text: any, limit: int) -> str {
    # UTF-16 units, as JavaScript's length and slice count them.
    return text
        if text.length <= limit
        else globalThis.String.prototype.trimEnd.call(
            globalThis.String.prototype.slice.call(text, 0, limit - 3)
        )
            + "...";
}

def sanitizeProviderErrorMessage(message: any = None) -> str {
    text: any = globalThis.String.prototype.trim.call(
        globalThis.String("" if missing(message) else message)
    );
    if not text {
        return "Provider error";
    }
    # Indexed, not unpacked: unpacking a tuple goes through the runtime, while
    # an item of the typed list is read directly.
    for redaction in REDACTIONS {
        text = globalThis.String.prototype.replace.call(text, redaction[0], redaction[1]);
    }
    return capped(globalThis.String.prototype.trim.call(text), 240);
}

# One line per failover attempt, for request_attempts.error_summary.
def summarizeAttemptError(message: any = None) -> str {
    return capped(sanitizeProviderErrorMessage(message), 200);
}
