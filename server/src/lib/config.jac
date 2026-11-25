import from "node:process" { default as process }

type Config = any;

glob:priv MB: int = 1024 * 1024;

def:priv env(name: str) -> str {
    raw: any = process.env[name];
    return raw.strip() if isinstance(raw, str) else "";
}

def:priv csv(raw: str) -> list[str] {
    return [s.strip() for s in raw.split(",") if s.strip()];
}

def loadConfig -> any {
    rpm: any = globalThis.Number(env("PROXY_RATE_LIMIT_RPM") or "x");
    # The JSON body ceiling of the LLM surfaces. A replayed session with inline
    # base64 screenshots was seen at 11.85MB, and express.json holds the whole
    # body in memory, so 25MB clears it while a few concurrent maximal bodies
    # still fit a 512MB host. REQUEST_BODY_LIMIT_MB raises it.
    bodyMb: any = globalThis.Number(env("REQUEST_BODY_LIMIT_MB") or "x");
    return plain(
        port=process.env.PORT ?? 3001,
        # Dual-stack, so the dashboard answers over IPv4 and IPv6 (#180).
        host=process.env.HOST ?? "::",
        dbPath=env("FREEAPI_DB_PATH") or NULL,
        dashboardOrigins=csv(process.env.DASHBOARD_ORIGINS ?? ""),
        clientDist=process.env.CLIENT_DIST ?? NULL,
        proxyRateLimitRpm=globalThis.Math.floor(rpm)
            if globalThis.Number.isFinite(rpm) and rpm >= 0
            else 120,
        requestBodyLimitBytes=(
            globalThis.Math.floor(bodyMb)
                if globalThis.Number.isFinite(bodyMb) and bodyMb >= 1
                else 25
        )
            * MB,
        nodeEnv=process.env.NODE_ENV ?? "development",
        serveStaticAssets=True,
        trustProxy=parseTrustProxy(),
        cspUpgradeInsecureRequests=parseCspUpgradeInsecureRequests(),
        allowedHosts=csv(env("ALLOWED_HOSTS").lower()),
    );
}

# TRUST_PROXY (#1024): unset or false trusts no forwarded header; true trusts
# every proxy; a number trusts that many hops from the socket peer (1 is one
# proxy in front, Express's idiom); else a list of proxy addresses or CIDRs.
def:priv parseTrustProxy -> any {
    lower = env("TRUST_PROXY").lower();
    if lower in ["true", "yes"] {
        return True;
    }
    if lower.isdigit() {
        hops: any = globalThis.Number(lower);
        return hops if hops > 0 else False;
    }
    addrs = csv(process.env.TRUST_PROXY ?? "") if lower not in ["", "false", "no"] else [];
    return addrs or False;
}

# CSP upgrade-insecure-requests (#682): forced on or off, else automatic, only
# for a request that arrived over TLS, so HTTP LAN installs still render.
def:priv parseCspUpgradeInsecureRequests -> any {
    lower = env("CSP_UPGRADE_INSECURE_REQUESTS").lower();
    return True
        if lower in ["true", "1", "yes"]
        else False if lower in ["false", "0", "no"] else None;
}
