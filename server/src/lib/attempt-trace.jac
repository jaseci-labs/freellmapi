import from "async_hooks" { AsyncLocalStorage }

# The failover ladder one proxied request walked (groq 429, google timeout,
# cerebras ok): the fallback loop adds a record per attempt and request-log
# persists them into request_attempts, keyed to the last `requests` row noted
# here. It travels on AsyncLocalStorage, so logRequest() outside a loop run
# (fusion sub-calls, embeddings, media) sees no trace.
type AttemptOutcome = any;

type AttemptTraceRecord = any;

type RequestTrace = any;

glob:priv storage: any = new(AsyncLocalStorage);

def newRequestTrace -> any {
    return globalThis.JSON.parse('{"records": [], "lastRequestRowId": null}');
}

def runWithRequestTrace(trace: any, fn: any) -> any {
    return storage.run(trace, fn);
}

def getRequestTrace -> any {
    return storage.getStore();
}

def noteRequestRowId(id: any) {
    trace: any = storage.getStore();
    if trace {
        trace.lastRequestRowId = globalThis.Number(id);
    }
}
