# Per-model output-token ceilings learned from provider rejections. Clients
# size max_tokens for the model they think they reach (Claude Code asks for
# 128000), and several free models reject rather than clamp. The first
# rejection teaches the ceiling, which every later request on that model and
# endpoint is clamped to (per endpoint, as tool-capability is, since custom
# relays share platform 'custom'). A restart forgets them.
glob MIN_LEARNED_OUTPUT_CAP: int = 1024;

glob:priv learned: dict[str, float] = {},
          NULL: any = globalThis.JSON.parse("null"),
          PARAMS: str = "max[_ ]tokens|max_completion_tokens|max_output_tokens|max_output|maxoutputtokens|max_new_tokens",
          # The number after a ceiling phrase. No bare "exceeds N": that reads
          # any number in a message ("exceeds 30000 TPM").
          PHRASE: str = "(?:less than or equal to|must be less than|at most|no (?:more|greater) than|(?:cannot|must not|can not) exceed|greater than the maximum|maximum output tokens|maximum allowed value|max output tokens|maximum value|output limit|maximum is|exceeds (?:the )?model(?:'s)? max_output)\\W{0,4}(?:of\\s+)?\\W{0,2}(\\d{3,7})",
          PARAM: any = new(globalThis.RegExp, f"\\b(?:{PARAMS})\\b"),
          # The phrase must follow the parameter within one clause.
          CEILING: any = new(globalThis.RegExp, f"\\b(?:{PARAMS})\\b[^.;]{{0,60}}?{PHRASE}");

def:priv capKey(platform: str, modelId: str, endpointScope: any = None) -> str {
    return modelStatsKey(platform, modelId, endpointScope);
}

# Both the parameter and a ceiling phrase must appear, so a context-window
# rejection that only mentions "maximum output tokens" never matches.
def parseMaxTokensCeiling(message: any = None) -> any {
    msg: any = globalThis.String(message ?? "").toLowerCase();
    found: any = CEILING.exec(msg) if PARAM.test(msg) else NULL;
    ceiling: any = globalThis.Number(found[1]) if found else 0;
    return ceiling if globalThis.Number.isFinite(ceiling) and ceiling > 0 else NULL;
}

# The lowest reading wins; one under MIN_LEARNED_OUTPUT_CAP is a misread.
def learnOutputCapFromError(route: any, err: any = None) -> any {
    status: any = getattr(err, "status", None) if err else None;
    if isinstance(status, (int, float)) and status not in [0, 400, 422] {
        return NULL;
    }
    ceiling: any = parseMaxTokensCeiling(getattr(err, "message", None) if err else None);
    if ceiling is NULL or ceiling < MIN_LEARNED_OUTPUT_CAP {
        return NULL;
    }
    key = capKey(route.platform, route.modelId, getattr(route, "endpointScope", None));
    learned[key] = min(learned.get(key, ceiling), ceiling);
    return ceiling;
}

def learnedOutputCap(platform: str, modelId: str, endpointScope: any = None) -> any {
    return learned.get(capKey(platform, modelId, endpointScope));
}

# What the context window leaves after the input, lowered to a learned cap.
def routeOutputBudget(route: any, estimatedInputTokens: float) -> any {
    window: any = getattr(route, "contextWindow", None);
    left: any = None if window is None or window is NULL else window - estimatedInputTokens;
    cap: any = learnedOutputCap(
        route.platform, route.modelId, getattr(route, "endpointScope", None)
    );
    return left if cap is None else cap if left is None else min(left, cap);
}

def resetLearnedOutputCaps {
    learned.clear();
}
