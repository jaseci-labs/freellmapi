import type { Request } from 'express';
import type { ChatMessage } from '@freellmapi/shared/types.js';
export type TaskType = 'code' | 'chat' | 'auto';
export declare const TASK_TYPE_HEADER = "x-freellm-task-type";
export declare function parseTaskTypeHeader(req: Request): TaskType;
export declare function deriveTaskType(tools: unknown[] | undefined, messages: ChatMessage[] | undefined): 'code' | 'chat';
export declare function resolveTaskType(req: Request, tools: unknown[] | undefined, messages: ChatMessage[] | undefined): 'code' | 'chat' | undefined;
