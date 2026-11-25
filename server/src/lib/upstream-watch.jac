import from "node:async_hooks" { AsyncLocalStorage }

# The fallback loop's silent-window cap (#1960): the loop runs each streaming
# dispatch inside runWithUpstreamWatch, and the SSE readers report opened() and
# activity() through currentUpstreamWatch(). AsyncLocalStorage, so that none of
# the ~40 adapters threads a callback through.
type UpstreamStreamWatch = any;

glob:priv store: any = new(AsyncLocalStorage);

def runWithUpstreamWatch(watch: any, fn: any) -> any {
    return store.run(watch, fn);
}

def currentUpstreamWatch -> any {
    return store.getStore();
}
