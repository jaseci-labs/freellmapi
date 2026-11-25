# What the server's Jac modules need of JavaScript itself, where the values
# they hand to TypeScript must be JavaScript's own.
glob NULL: any = globalThis.JSON.parse("null");

glob:priv patterns: dict[str, any] = {};

def rx(pattern: str, flags: str = "") -> any {
    return new(globalThis.RegExp, pattern, flags);
}

# String.prototype.replace with a regular expression of JavaScript's, each
# pattern compiled once: replace starts a global one from lastIndex 0, so a
# kept RegExp carries nothing from one call to the next.
def sub(text: any, pattern: str, replacement: str, flags: str = "") -> str {
    key = flags + "/" + pattern;
    compiled: any = patterns.get(key);
    if compiled is None {
        compiled = rx(pattern, flags);
        patterns[key] = compiled;
    }
    return globalThis.String.prototype.replace.call(text, compiled, replacement);
}

# A plain object of JavaScript's, where a dict would cross as a Map. Made by
# the runtime's own conversion of a dict, not Object.fromEntries over
# fields.items(): that walks a generator of tuples, 15x the cost.
def plain(**fields: any) -> any {
    return globalThis.Object(fields);
}

# JavaScript's `x == null`: undefined or null.
def missing(value: any) -> bool {
    return value is None or value is NULL;
}
