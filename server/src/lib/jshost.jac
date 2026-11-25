# What the server's Jac modules need of JavaScript itself, where the values
# they hand to TypeScript must be JavaScript's own.
glob NULL: any = globalThis.JSON.parse("null");

# String.prototype.replace with a regular expression of JavaScript's.
def sub(text: any, pattern: str, replacement: str, flags: str = "") -> str {
    return globalThis.String.prototype.replace.call(
        text, new(globalThis.RegExp, pattern, flags), replacement
    );
}

def rx(pattern: str, flags: str = "") -> any {
    return new(globalThis.RegExp, pattern, flags);
}

# A plain object of JavaScript's, where a dict would cross as a Map.
def plain(**fields: any) -> any {
    return globalThis.Object.fromEntries(fields.items());
}
