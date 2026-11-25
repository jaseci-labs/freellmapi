export declare const REQUEST_MAX_TOKENS_BUDGET_SETTING = "request_max_tokens_budget";
export declare const MAX_CONSECUTIVE_UPSTREAM_FAILS_SETTING = "max_consecutive_upstream_fails";
export declare function getRequestMaxTokensBudget(): number;
export declare function getMaxConsecutiveUpstreamFails(): number;
export interface TokenBudgetRejection {
    budget: number;
    estimatedTotal: number;
}
export interface TokenBudgetResult {
    rejection: TokenBudgetRejection | null;
    maxTokens: number | undefined;
}
export declare const TOKEN_BUDGET_OUTPUT_CAP = 4096;
export declare function applyTokenBudget(estimatedInputTokens: number, maxTokens: number | undefined): TokenBudgetResult;
export declare function tokenBudgetMessage(r: TokenBudgetRejection): string;
export interface BreakerState {
    limit: number;
    consecutive: number;
}
export declare function newBreaker(limit?: number): BreakerState;
export declare function recordBreakerFailure(state: BreakerState): boolean;
