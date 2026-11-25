export interface UpstreamStreamWatch {
    opened(patienceMs: number): void;
    activity(): void;
}
export declare function runWithUpstreamWatch<T>(watch: UpstreamStreamWatch | undefined, fn: () => T): T;
export declare function currentUpstreamWatch(): UpstreamStreamWatch | undefined;
