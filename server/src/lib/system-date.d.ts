import type { ChatMessage } from '@freellmapi/shared/types.js';
export interface ToolLike {
    type?: string;
    function?: {
        name?: string;
    };
}
export declare const SYSTEM_DATE_SETTING = "inject_system_date";
export declare const SYSTEM_DATE_MODES: readonly ["off", "web_search", "always"];
export type SystemDateMode = (typeof SYSTEM_DATE_MODES)[number];
export declare function getSystemDateMode(): SystemDateMode;
export declare function setSystemDateMode(mode: SystemDateMode): SystemDateMode;
export declare function formatSystemDatePrompt(now?: Date): string;
export declare function hasWebSearchInRequest(messages: readonly ChatMessage[], tools?: readonly ToolLike[]): boolean;
export declare function alreadyHasDateContext(messages: readonly ChatMessage[]): boolean;
export declare function maybeInjectSystemDate(messages: ChatMessage[], opts?: {
    mode?: SystemDateMode;
    tools?: readonly ToolLike[];
    now?: Date;
}): ChatMessage[];
