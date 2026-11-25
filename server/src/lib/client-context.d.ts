import type { NextFunction, Request, Response } from 'express';
import { type ClientAgent } from './client-classifier.js';
import type { PresetStrategy } from '../services/scoring.js';
export interface ClientContext {
    ip: string | null;
    userAgent: string | null;
    agent: ClientAgent | null;
    routingStrategy?: PresetStrategy;
}
export declare function clientContextMiddleware(req: Request, _res: Response, next: NextFunction): void;
export declare function getClientContext(): ClientContext;
export declare function setRequestRoutingStrategy(strategy: PresetStrategy | undefined): void;
