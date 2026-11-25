import from "ajv/dist/2020.js" { default as Ajv2020 }
import from "node:process" { default as process }

# Whether a tool call's arguments satisfy the schema the caller declared.
# tool-args repairs what it provably can; a call still wrong would reach the
# Anthropic surface as `input: {}`, which reads to an agent as the model
# choosing to call the tool with nothing. Free models are the ones that emit
# such calls and another model usually gets it right, so a violation throws
# before anything is committed and the loop fails over. Off by default: a
# false positive costs a failover hop.
type ToolArgumentVerdict = any;

glob TOOL_ARGUMENT_VALIDATION_SETTING: str = "validate_tool_arguments";

# 2020-12, which zod-to-json-schema and Pydantic v2 emit. Not strict, since
# real schemas carry vendor keywords.
glob:priv ajv: any = new(Ajv2020, plain(strict=False, allErrors=True, validateFormats=False)),
          # A schema Ajv refuses is cached too (NULL), never recompiled.
          compiled: dict[str, any] = {},
          # Tool schemas are the same object for every call of a request.
          stableKeys: any = new(globalThis.WeakMap);

def isToolArgumentValidationEnabled -> bool {
    try {
        stored: any = getSetting(TOOL_ARGUMENT_VALIDATION_SETTING);
    } except Exception {
        stored = None;
    }
    for raw in [stored, process.env.VALIDATE_TOOL_ARGUMENTS] {
        if isinstance(raw, str) and raw.strip() {
            return raw.strip().lower() in ["1", "true"];
        }
    }
    return False;
}

# Key order does not matter, so schemas that differ only in it share one
# compiled validator.
def stableStringify(value: any = None) -> str {
    if globalThis.Array.isArray(value) {
        return "[" + ",".join(stableStringify(v) for v in value) + "]";
    }
    if value is NULL or callable(value) or globalThis.Object(value) is not value {
        return globalThis.JSON.stringify(value) ?? "null";
    }
    entries = sorted(
        [e for e in globalThis.Object.entries(value) if e[1] is not None],
        key=lambda (e: any) -> str { e[0] },
    );
    return "{"
        + ",".join(globalThis.JSON.stringify(e[0]) + ":" + stableStringify(e[1]) for e in entries)
        + "}";
}

def:priv compiledFor(schema: any) -> any {
    key: any = stableKeys.get(schema);
    if key is None {
        key = stableStringify(schema);
        stableKeys.set(schema, key);
    }
    if key not in compiled {
        # Without `$schema`: an unknown dialect is fatal to compile, and the
        # dialect is not what is checked.
        rest: any = globalThis.Object.assign(plain(), schema);
        globalThis.Reflect.deleteProperty(rest, "$schema");
        try {
            compiled[key] = ajv.compile(rest);
        } except Exception {
            compiled[key] = NULL;
        }
    }
    return compiled[key];
}

# Fails open wherever no opinion can be formed: no schema, one Ajv will not
# compile, arguments that are not a JSON object. Only a definite violation is
# a verdict, since a verdict costs a failover hop.
def validateToolArguments(toolName: str, argsJson: str, schema: any = None) -> any {
    validate: any = compiledFor(schema) if schema and globalThis.Object(schema) is schema else NULL;
    if not validate {
        return plain(ok=True);
    }
    try {
        parsed: any = globalThis.JSON.parse(argsJson);
    } except Exception {
        return plain(ok=True);
    }
    if not parsed
        or globalThis.Object(parsed) is not parsed
        or globalThis.Array.isArray(parsed)
        or validate(parsed)
    {
        return plain(ok=True);
    }
    detail = "; ".join(
        f"{e.instancePath or '/'} {e.message ?? 'is invalid'}"
        for e in list(validate.errors or [])[:3],
    );
    return plain(ok=False, reason=f"{toolName}: {detail or 'does not match its schema'}");
}

# Its message carries `invalid tool arguments`, which isRetryableError knows.
# skipBench: the provider is healthy. skipModelForRequest: a sibling key would
# do the same.
def invalidToolArgumentsError(displayName: str, reasons: list[str]) -> any {
    return globalThis.Object.assign(
        new(
            globalThis.Error,
            f"invalid tool arguments from {displayName} ({'; '.join(list(reasons)[:3])})",
        ),
        plain(skipBench=True, skipModelForRequest=True),
    );
}

# The reasons of a turn's calls that violate their schema; none is servable.
def invalidToolCallReasons(calls: any, schemas: any) -> list[str] {
    reasons: list[str] = [];
    for call in calls or [] {
        fn: any = getattr(call, "function", None);
        name: any = getattr(fn, "name", None) if fn else None;
        args: any = getattr(fn, "arguments", None) if fn else None;
        schema: any = schemas.get(name) if name and isinstance(args, str) else None;
        if schema is not None {
            verdict: any = validateToolArguments(name, args, schema);
            if not verdict.ok {
                reasons.append(verdict.reason);
            }
        }
    }
    return reasons;
}
