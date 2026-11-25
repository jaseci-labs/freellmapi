export declare function normalizeModelIdForDrift(id: string): string;
export declare function resetServedModelObservations(): void;
export declare function observeServedModel(opts: {
    platform: string;
    requestedModel: string;
    servedModel: string | null | undefined;
}): string | null;
