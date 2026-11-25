export declare const RETIREMENT_CONFIRMATIONS_REQUIRED = 2;
export declare const RETIREMENT_OBSERVATION_WINDOW_MS: number;
export declare function resetModelRetirementObservations(): void;
export interface RetirementRoute {
    modelDbId: number;
    platform: string;
    modelId: string;
    endpointScope?: string;
}
export declare function noteModelRetirementSignal(route: RetirementRoute, err: unknown, requestToken?: unknown): boolean;
