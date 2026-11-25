import type { ChatMessage } from '@freellmapi/shared/types.js';
export declare const CLIENT_PROFILE_KEY_PREFIX = "sk-cp-";
export declare function timingSafeStringEqual(provided: string, expected: string): boolean;
export declare function mintClientProfileKey(): string;
export declare function hashClientProfileKey(key: string): string;
export type ResolvedAuth = {
    kind: 'unified';
    systemPrompt: null;
} | {
    kind: 'profile';
    profileId: number;
    name: string;
    systemPrompt: string | null;
};
export declare function resolveAuth(token: string | undefined): ResolvedAuth | null;
export declare function prependSystemPrompt(messages: ChatMessage[], prompt: string | null | undefined): ChatMessage[];
