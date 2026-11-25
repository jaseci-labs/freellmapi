export declare function providerTimeoutEnvName(platform: string): string;
export declare function providerTimeoutMs(platform: string, defaultMs: number): number;
export declare const DEFAULT_STREAM_STALL_TIMEOUT_MS = 90000;
export declare function streamStallTimeoutEnvName(platform: string): string;
export declare function streamStallTimeoutMs(platform?: string): number;
export declare function resetTimeoutWarnings(): void;
