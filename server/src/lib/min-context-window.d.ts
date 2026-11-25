export declare const MIN_CONTEXT_WINDOW_SETTING = "min_context_window";
export declare const MIN_CONTEXT_WINDOW_PRESETS: Record<string, number>;
export declare function minContextWindowFloor(): number | null;
export declare function passesContextWindowFloor(contextWindow: number | null | undefined): boolean;
