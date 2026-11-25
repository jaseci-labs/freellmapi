# Served-model drift guard (#534). The gateway overwrites the upstream `model`
# with the routed id (provider metadata is unreliable: Reka answers "default",
# #568), which also hides a provider silently serving another model. This
# takes the raw upstream value from before the overwrite and, where it differs
# beyond spelling, logs it once per (platform, requested, served) and returns
# it for requests.served_model. Callers still see the routed model.
glob:priv PLACEHOLDERS: list[str] = ["", "default", "unknown"],
          observed: set[str] = set();

# Cosmetic differences: case, one trailing tier tag (":free"), the namespace
# before the last '/', and separator runs (as model-groups' normalizeGroupKey).
# JavaScript's string methods are called through String.prototype: on a value
# typed any, s.trim() is a dynamic call through the runtime, 20x the cost.
def normalizeModelIdForDrift(id: any) -> str {
    s: any = globalThis.String.prototype.toLowerCase.call(
        globalThis.String.prototype.trim.call(globalThis.String("" if missing(id) else id))
    );
    s = sub(s, ":(free|beta|extended|nitro|standard)$", "");
    s = globalThis.String.prototype.slice.call(
        s, globalThis.String.prototype.lastIndexOf.call(s, "/") + 1
    );
    return sub(s, "[\\s_-]+", "-", "g").strip();
}

def resetServedModelObservations {
    observed.clear();
}

# The raw served id where it genuinely differs, else null. The warn cache is
# capped at 1000 tuples, so an upstream that invents ids cannot grow it.
def observeServedModel(opts: any) -> any {
    served: any = getattr(opts, "servedModel", None);
    if not isinstance(served, str) {
        return NULL;
    }
    served = globalThis.String.prototype.trim.call(served);
    requested: str = opts.requestedModel;
    if globalThis.String.prototype.toLowerCase.call(served) in PLACEHOLDERS
        or normalizeModelIdForDrift(requested) == normalizeModelIdForDrift(served)
    {
        return NULL;
    }
    seen = f"{opts.platform} {requested} {served}";
    if seen not in observed and len(observed) < 1000 {
        observed.add(seen);
        globalThis.console.warn(
            f"[ServedModel] platform={opts.platform} requested={requested} served={served} — upstream reported a different model than the routed id (#534). Response contract unchanged (clients still see the routed model); drift recorded in requests.served_model.",
        );
    }
    return served;
}
