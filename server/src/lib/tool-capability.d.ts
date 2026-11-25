export declare const TOOL_REJECTION_LIMIT = 3;
export declare const TOOL_REJECTION_WINDOW_MS: number;
export declare const TOOL_BENCH_MS: number;
export declare function toolCapabilityKey(platform: string, modelId: string, endpointScope: string | null | undefined): string;
export declare function benchForTools(key: string, now?: number): void;
export declare function noteToolRejection(key: string, now?: number): void;
export declare function clearToolRejections(key: string): void;
export declare function isToolBenched(platform: string, modelId: string, endpointScope: string | null | undefined, now?: number): boolean;
export declare function resetToolCapability(): void;
