import from "node:process" { default as process }

# PROVIDER_TIMEOUT_<PLATFORM>=<ms> overrides a platform's chat timeout (#547),
# read when the provider is constructed; 0 disables it.
# PROVIDER_STREAM_STALL_TIMEOUT_MS is how long an SSE stream may go without a
# byte (#553), and PROVIDER_STREAM_STALL_TIMEOUT_<PLATFORM> overrides it for
# one platform (#584). The first byte is bounded by the chat timeout instead:
# see BaseProvider.readSseStream.
glob DEFAULT_STREAM_STALL_TIMEOUT_MS: int = 90000;

glob:priv warned: any = new(globalThis.Set);

def:priv warnOnce(name: str, message: str) {
    if not warned.has(name) {
        warned.add(name);
        globalThis.console.warn(message);
    }
}

def:priv parseTimeoutEnv(name: str, defaultMs: float) -> float {
    raw: any = process.env[name];
    if raw is None or raw.trim() == "" {
        return defaultMs;
    }
    parsed: any = globalThis.Number(raw.trim());
    if not globalThis.Number.isInteger(parsed) or parsed < 0 {
        warnOnce(
            name,
            f"[config] Ignoring {name}=\"{raw}\": expected a non-negative integer of milliseconds (0 disables the timeout). Using the default {defaultMs}ms.",
        );
        return defaultMs;
    }
    if 0 < parsed < 1000 {
        warnOnce(
            name,
            f"[config] {name}={parsed}ms is under a second; nearly every request to this provider will abort. Was this meant to be seconds?",
        );
    }
    return parsed;
}

def:priv envName(prefix: str, platform: any) -> str {
    return prefix + sub(platform.toUpperCase(), "[^A-Z0-9]", "_", "g");
}

def providerTimeoutEnvName(platform: str) -> str {
    return envName("PROVIDER_TIMEOUT_", platform);
}

# 0 means no timeout: a caller skips its abort timer, never setTimeout(0).
def providerTimeoutMs(platform: str, defaultMs: float) -> float {
    return parseTimeoutEnv(providerTimeoutEnvName(platform), defaultMs);
}

def streamStallTimeoutEnvName(platform: str) -> str {
    return envName("PROVIDER_STREAM_STALL_TIMEOUT_", platform);
}

def streamStallTimeoutMs(platform: any = None) -> float {
    globalMs = parseTimeoutEnv("PROVIDER_STREAM_STALL_TIMEOUT_MS", DEFAULT_STREAM_STALL_TIMEOUT_MS);
    return parseTimeoutEnv(streamStallTimeoutEnvName(platform), globalMs) if platform else globalMs;
}

def resetTimeoutWarnings {
    warned.clear();
}
