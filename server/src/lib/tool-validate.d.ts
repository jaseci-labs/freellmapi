export declare const TOOL_ARGUMENT_VALIDATION_SETTING = "validate_tool_arguments";
export declare function isToolArgumentValidationEnabled(): boolean;
export declare function stableStringify(value: unknown): string;
export type ToolArgumentVerdict = {
    ok: true;
} | {
    ok: false;
    reason: string;
};
export declare function validateToolArguments(toolName: string, argsJson: string, schema: unknown): ToolArgumentVerdict;
export declare function invalidToolArgumentsError(displayName: string, reasons: string[]): Error;
export declare function invalidToolCallReasons(calls: Array<{
    function?: {
        name?: string;
        arguments?: string;
    };
}> | undefined, schemas: Map<string, unknown>): string[];
