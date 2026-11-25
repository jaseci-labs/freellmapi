import from "node:process" { default as process }

# Notices that the host slept (lid closed, VM paused), when every timer and
# socket froze, so the server can drop stale state at once rather than at the
# next 5-minute health cycle. A 5s heartbeat that finds the clock 30s ahead
# means a suspend; SIGCONT and SIGUSR2 force a pass (SIGUSR1 would open the
# inspector). One pass per resume: wakes within 15s of the last are dropped.
# From Naster17/freellmapi-pro@4c43cf2a, trimmed to what applies here.
type WakeHooks = any;

type WakeEvent = any;

glob:priv TICK_MS: int = 5000,
          hooks: any = None,
          timer: any = None,
          lastTickAt: float = 0,
          lastWakeAt: float = 0;

def:priv onSigcont {
    handleSignal("SIGCONT");
}

def:priv onSigusr2 {
    handleSignal("SIGUSR2");
}

def:priv schedule {
    timer = globalThis.setTimeout(tick, TICK_MS);
    timer.unref();
}

def:priv tick {
    now = globalThis.Date.now();
    drift = now - lastTickAt - TICK_MS;
    if lastTickAt > 0 and drift > 30000 {
        invokeHooks(globalThis.Object.fromEntries([("reason", "drift"), ("idleMs", drift)]));
    }
    lastTickAt = now;
    schedule();
}

def:priv handleSignal(name: str) {
    idle = max(0, globalThis.Date.now() - lastTickAt - TICK_MS) if lastTickAt > 0 else 0;
    invokeHooks(
        globalThis.Object.fromEntries([("reason", "signal"), ("idleMs", idle), ("signal", name)])
    );
    lastTickAt = globalThis.Date.now();
}

def:priv logError(how: str, err: any) {
    globalThis.console.error(
        f"[wake-detect] onWake handler {how}: {getattr(err, 'message', None) ?? err}"
    );
}

# A recovery pass never takes the server down: a throwing handler is logged.
def:priv invokeHooks(event: any) {
    now = globalThis.Date.now();
    if hooks is None or now - lastWakeAt < 15000 {
        return;
    }
    lastWakeAt = now;
    try {
        globalThis.Promise.resolve(hooks.onWake(event)).catch(
            lambda (err: any) { logError("error", err); }
        );
    } except Exception as err {
        logError("threw synchronously", err);
    }
}

def startWakeDetect(h: any) {
    if hooks is None {
        hooks = h;
        lastTickAt = globalThis.Date.now();
        schedule();
        process.on("SIGCONT", onSigcont);
        process.on("SIGUSR2", onSigusr2);
    }
}

# Removes only this module's listeners, not another module's SIGUSR2 handler.
def stopWakeDetect {
    if hooks is not None {
        globalThis.clearTimeout(timer);
        process.removeListener("SIGCONT", onSigcont);
        process.removeListener("SIGUSR2", onSigusr2);
        hooks = None;
        lastTickAt = 0;
        lastWakeAt = 0;
    }
}

def _resetForTests {
    stopWakeDetect();
}
