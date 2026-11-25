export declare function isTransportError(err: unknown): boolean;
export type ProcessErrorDecision = 'swallow' | 'fatal';
export declare function classifyProcessError(err: unknown): ProcessErrorDecision;
export interface SafetyNetHooks {
    log?: (...args: unknown[]) => void;
    exit?: (code: number) => void;
    hasProcessHooks?: boolean;
}
export declare function handleProcessError(kind: 'uncaughtException' | 'unhandledRejection', err: unknown, hooks?: SafetyNetHooks): ProcessErrorDecision;
export declare function isBrokenPipeWrite(err: unknown): boolean;
export declare function guardStdio(streams?: NodeJS.EventEmitter[]): void;
export declare function installProcessSafetyNet(hooks?: SafetyNetHooks): void;
