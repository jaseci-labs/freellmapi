export declare const MIN_LEARNED_OUTPUT_CAP = 1024;
export declare function parseMaxTokensCeiling(message: unknown): number | null;
export declare function learnOutputCapFromError(route: {
    platform: string;
    modelId: string;
    endpointScope?: string | null;
}, err: any): number | null;
export declare function learnedOutputCap(platform: string, modelId: string, endpointScope?: string | null): number | undefined;
export declare function routeOutputBudget(route: {
    platform: string;
    modelId: string;
    contextWindow?: number | null;
    endpointScope?: string | null;
}, estimatedInputTokens: number): number | undefined;
export declare function resetLearnedOutputCaps(): void;
