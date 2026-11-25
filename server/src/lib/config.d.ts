export interface Config {
    port: number | string;
    host: string;
    dbPath: string | null;
    dashboardOrigins: string[];
    clientDist: string | null;
    proxyRateLimitRpm: number;
    requestBodyLimitBytes: number;
    nodeEnv: string;
    serveStaticAssets: boolean;
    trustProxy: boolean | number | string[];
    cspUpgradeInsecureRequests: boolean | undefined;
    allowedHosts: string[];
}
export declare function loadConfig(): Config;
