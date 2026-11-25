# Task-type-aware routing (#1127): a client may declare whether a request is
# code or chat, so the router leans toward quality or speed. Without the
# header, a tool-bearing request or a code marker in the last user message
# makes it code. The result is only a lean: undefined leaves the weights alone.
type TaskType = any;

glob TASK_TYPE_HEADER: str = "x-freellm-task-type";

# Each marker is syntax, never vocabulary: bare words such as `function` or
# `class` classified "What class of animals are dolphins?" as code once, and a
# false positive silently re-weights ordinary chat.
glob:priv CODE_MARKERS: list[any] = [
    rx("```"),
    rx("^[ \\t]*\\$[ \\t]+[a-z][\\w./-]*(?=[ \\t]|$)", "m"),
    rx("\\b(?:const|let|var)\\s+[A-Za-z_$][\\w$]*\\s*="),
    rx("\\bfunction\\s*\\*?\\s*[A-Za-z_$][\\w$]*\\s*\\("),
    rx("\\bdef\\s+[A-Za-z_]\\w*\\s*\\("),
    rx("^[ \\t]*class\\s+[A-Za-z_$][\\w$]*\\s*[({:]", "m"),
    rx("\\bclass\\s+[A-Za-z_$][\\w$]*\\s+extends\\s+[A-Za-z_$][\\w$]*"),
    rx("\\bimport\\s*\\{"),
    rx("\\bimport\\s[^\\n;]{0,200}?\\bfrom\\s*['\\x22][^'\\x22\\n]+['\\x22]"),
    rx("^[ \\t]*from\\s+[A-Za-z_.][\\w.]*\\s+import\\s+\\S", "m"),
    rx("\\brequire\\s*\\(\\s*['\\x22]"),
    rx("^[ \\t]*#\\s*include\\s*[<\\x22]", "m"),
    # A source path and line number, `src/router.ts:214`.
    rx(
        "\\b[\\w./-]+\\.(?:[jt]sx?|mjs|cjs|py|rb|go|rs|java|kt|swift|php|cs|cpp|cc|hpp|sh|sql|css|scss|html|vue|svelte|ya?ml|json|toml)\\s*:\\s*\\d+",
    ),
    rx("\\b[A-Za-z_][\\w./-]*\\.[ch]\\s*:\\s*\\d+"),
    # Stack frames of V8 and Python.
    rx("^\\s*at\\s+\\S.*\\(.*:\\d+:\\d+\\)", "m"),
    rx("^\\s*File\\s+\\x22[^\\x22\\n]+\\x22,\\s*line\\s+\\d+", "m"),
    rx("\\bTraceback\\s+\\(most recent call last\\)"),
];

def:priv rx(pattern: str, flags: str = "") -> any {
    return new(globalThis.RegExp, pattern, flags);
}

def parseTaskTypeHeader(req: any) -> str {
    raw: any = req.headers[TASK_TYPE_HEADER];
    value: any = raw[0] if globalThis.Array.isArray(raw) else raw;
    declared: str = value.trim().toLowerCase() if isinstance(value, str) else "";
    return declared if declared in ["code", "chat", "auto"] else "auto";
}

# Reads at most 4000 characters of the last user message.
def deriveTaskType(tools: any = None, messages: any = None) -> str {
    if tools and tools.length > 0 {
        return "code";
    }
    for m in reversed(list(messages or [])) {
        if m.role == "user" {
            text: any = contentToString(m.content).slice(0, 4000);
            return "code" if any(re.test(text) for re in CODE_MARKERS) else "chat";
        }
    }
    return "chat";
}

# The header wins. `auto` only ever leans toward code: re-weighting the bulk
# of ordinary chat traffic would defeat an opt-in knob.
def resolveTaskType(req: any, tools: any = None, messages: any = None) -> any {
    declared = parseTaskTypeHeader(req);
    if declared != "auto" {
        return declared;
    }
    return "code" if deriveTaskType(tools, messages) == "code" else None;
}
