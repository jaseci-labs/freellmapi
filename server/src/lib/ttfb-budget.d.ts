export interface EndpointTtfbStats {
    p50Ms: number;
    p95Ms: number;
    sampleCount: number;
    weightedSamples: number;
}
export declare function invalidateTtfbBudgetCache(): void;
export declare function getEndpointTtfbStats(platform: string, endpointScope?: string, now?: number): EndpointTtfbStats | null;
export declare function getEndpointTimeBudgetMs(baseBudgetMs: number, platform: string, endpointScope?: string, now?: number): number;
