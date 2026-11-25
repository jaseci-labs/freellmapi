export type ExecFileSyncLike = (file: string, args: string[], options: {
    encoding: 'utf8';
    timeout: number;
    windowsHide: true;
    stdio: ['ignore', 'pipe', 'pipe'];
}) => string;
export interface RestrictOptions {
    platform?: NodeJS.Platform;
    execFileSync?: ExecFileSyncLike;
    ownerSid?: string | null;
}
export declare function windowsRestrictArgs(target: string, ownerSid: string, opts?: {
    inheritable?: boolean;
}): string[];
export declare function restrictToOwner(target: string, opts?: RestrictOptions): boolean;
export declare function restrictDirToOwner(target: string, opts?: RestrictOptions): boolean;
export declare function restrictAllToOwner(targets: string[], opts?: RestrictOptions): string[];
