import from "node:process" { default as process }

# A gateway in front of flaky free providers must not exit because a CDN edge
# reset a socket after undici handed the response off, which Node raises as an
# uncaughtException with no listener. Only a tight allowlist of transport
# errors is swallowed; everything else still exits 1, so real bugs surface.
# From jasnoorgill's safe-fetch fork.
type ProcessErrorDecision = any;

type SafetyNetHooks = any;

glob:priv TRANSPORT_CODES: list[str] = [
              "ECONNRESET",
              "ECONNREFUSED",
              "ECONNABORTED",
              "ETIMEDOUT",
              "EPIPE",
              "EAI_AGAIN",
              "ENOTFOUND",
              "EHOSTUNREACH",
              "ENETUNREACH",
              "EADDRNOTAVAIL",
              "UND_ERR_SOCKET",
              "UND_ERR_CONNECT_TIMEOUT",
              "UND_ERR_HEADERS_TIMEOUT",
              "UND_ERR_BODY_TIMEOUT",
              "UND_ERR_ABORTED",
          ],
          TRANSPORT_HINTS: list[str] = [
              "fetch failed",
              "other side closed",
              "socket hang up",
              "terminated",
              "premature close",
              "econnreset",
              "request aborted",
          ],
          DEAD_STDIO_CODES: list[str] = ["EPIPE", "EOF", "ERR_STREAM_DESTROYED"],
          installed: bool = False;

# undici wraps the socket error in err.cause, sometimes deeper: the chain's
# (code, message) pairs, six deep at most and cycle-safe.
def:priv walkErrorChain(err: any) -> list[tuple[any, any]] {
    links: list[tuple[any, any]] = [];
    seen: list[any] = [];
    cur: any = err;
    while cur
        and globalThis.Object(cur) is cur
        and len(links) < 6
        and not any(s is cur for s in seen)
    {
        seen.append(cur);
        code: any = getattr(cur, "code", None);
        message: any = getattr(cur, "message", None);
        links.append((
            code if isinstance(code, str) else None,
            message if isinstance(message, str) else None,
        ));
        cur = getattr(cur, "cause", None);
    }
    return links;
}

def isTransportError(err: any = None) -> bool {
    if missing(err) {
        return False;
    }
    links = walkErrorChain(err);
    joined = " | ".join(m or "" for (_, m) in links).lower();
    return any(c in TRANSPORT_CODES for (c, _) in links if c)
        or any(h in joined for h in TRANSPORT_HINTS);
}

def classifyProcessError(err: any = None) -> str {
    return "swallow" if isTransportError(err) else "fatal";
}

def:priv describeError(err: any) -> str {
    links = walkErrorChain(err);
    code = next((c for (c, _) in links if c), None);
    message = next((m for (_, m) in links if m), None);
    return f"{code} ({message or 'no message'})" if code else message or globalThis.String(err);
}

# 'fatal' exits 1, as Node does by default; 'swallow' logs and continues. A
# write to a closed pipe is swallowed silently: logging it would write to the
# same dead pipe and raise the next EPIPE, at thousands of rows a second.
def handleProcessError(kind: str, err: any = None, hooks: any = None) -> str {
    log: any = (getattr(hooks, "log", None) if hooks else None) or globalThis.console.error;
    if classifyProcessError(err) == "swallow" {
        if not isBrokenPipeWrite(err) {
            log(f"[safety-net] swallowed transient {kind}: {describeError(err)}");
        }
        return "swallow";
    }
    log(f"[safety-net] fatal {kind}:", err);
    ((getattr(hooks, "exit", None) if hooks else None) or process.exit)(1);
    return "fatal";
}

def isBrokenPipeWrite(err: any = None) -> bool {
    return bool(err)
        and globalThis.Object(err) is err
        and getattr(err, "code", None) == "EPIPE"
        and getattr(err, "syscall", None) == "write";
}

def:priv onStdioError(err: any) {
    code: any = getattr(err, "code", None) if err else None;
    if not (isinstance(code, str) and code in DEAD_STDIO_CODES) {
        raise err;
    }
}

# Without an 'error' listener, a closed terminal or a gone parent turns every
# later console write into an uncaughtException. A dead console is dropped;
# any other stream error is thrown on.
def guardStdio(streams: any = None) {
    for stream in streams or [process.stdout, process.stderr] {
        stream.on("error", onStdioError);
    }
}

def:priv onUncaught(err: any) {
    handleProcessError("uncaughtException", err, hooksInstalled);
}

def:priv onRejection(reason: any) {
    handleProcessError("unhandledRejection", reason, hooksInstalled);
}

glob:priv hooksInstalled: any = None;

# Once, as early as boot allows; hasProcessHooks false registers nothing.
def installProcessSafetyNet(hooks: any = None) {
    if installed {
        return;
    }
    installed = True;
    if hooks and getattr(hooks, "hasProcessHooks", None) is False {
        return;
    }
    hooksInstalled = hooks;
    guardStdio();
    process.on("uncaughtException", onUncaught);
    process.on("unhandledRejection", onRejection);
}
