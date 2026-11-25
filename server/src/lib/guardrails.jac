import from "node:process" { default as process }

# Two per-request limits, both off (0) by default. request_max_tokens_budget
# rejects with 413 a request whose estimated input plus max_tokens exceeds it,
# and caps the output of one that sent no max_tokens. A request stops with 503
# after max_consecutive_upstream_fails failed attempts in a row, rather than
# grind through a pool that is failing across the board. The setting wins,
# then the env var. From coffcoe/freellmapi@e5024d53, wired once in
# runFallbackLoop.
type TokenBudgetRejection = any;

type TokenBudgetResult = any;

type BreakerState = any;

glob REQUEST_MAX_TOKENS_BUDGET_SETTING: str = "request_max_tokens_budget",
     MAX_CONSECUTIVE_UPSTREAM_FAILS_SETTING: str = "max_consecutive_upstream_fails",
     # The most output the budget injects where the client set none: forwarding
     # the whole remainder made providers reject the request on every candidate.
     TOKEN_BUDGET_OUTPUT_CAP: int = 4096;

def:priv readGuardrailValue(settingKey: str, envKey: str) -> float {
    try {
        stored: any = getSetting(settingKey);
    } except Exception {
        stored = None;
    }
    for raw in [stored, process.env[envKey]] {
        n: any = globalThis.Number(raw) if isinstance(raw, str) and raw.strip() else -1;
        if globalThis.Number.isInteger(n) and n >= 0 {
            return n;
        }
    }
    return 0;
}

def getRequestMaxTokensBudget -> float {
    return readGuardrailValue(REQUEST_MAX_TOKENS_BUDGET_SETTING, "REQUEST_MAX_TOKENS_BUDGET");
}

def getMaxConsecutiveUpstreamFails -> float {
    return readGuardrailValue(
        MAX_CONSECUTIVE_UPSTREAM_FAILS_SETTING, "MAX_CONSECUTIVE_UPSTREAM_FAILS"
    );
}

def applyTokenBudget(estimatedInputTokens: float, maxTokens: any = None) -> any {
    budget = getRequestMaxTokensBudget();
    total = estimatedInputTokens + (maxTokens ?? 0);
    rejected = plain(budget=budget, estimatedTotal=total);
    if budget <= 0 {
        return plain(rejection=NULL, maxTokens=maxTokens);
    }
    if total > budget or (maxTokens is None and budget - estimatedInputTokens < 1) {
        return plain(rejection=rejected, maxTokens=maxTokens);
    }
    if maxTokens is None {
        maxTokens = min(budget - estimatedInputTokens, TOKEN_BUDGET_OUTPUT_CAP);
    }
    return plain(rejection=NULL, maxTokens=maxTokens);
}

def tokenBudgetMessage(r: any) -> str {
    return f"Request exceeds the per-request token budget guardrail: ~{r.estimatedTotal} tokens (estimated input + requested output) over a budget of {r.budget}. Trim the prompt or lower max_tokens, or raise the {REQUEST_MAX_TOKENS_BUDGET_SETTING} setting (0 disables it).";
}

def newBreaker(limit: any = None) -> any {
    return plain(limit=limit ?? getMaxConsecutiveUpstreamFails(), consecutive=0);
}

# True when this failure reaches the limit; never with the breaker off.
def recordBreakerFailure(state: any) -> bool {
    if state.limit <= 0 {
        return False;
    }
    state.consecutive += 1;
    return state.consecutive >= state.limit;
}
