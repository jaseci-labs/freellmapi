export interface EncryptedProxyColumns {
    proxy_encrypted: string | null;
    proxy_iv: string | null;
    proxy_auth_tag: string | null;
}
export declare const KEY_PROXY_URL_ERROR = "proxyUrl must be a valid proxy URL using http, https, socks4, socks4a, socks5 or socks5h (e.g. socks5://user:pass@host:1080), or '' to clear it";
export declare const KEY_PROXY_URL_MAX = 2048;
export declare function isValidKeyProxyUrl(url: string): boolean;
export declare function encryptProxyUrl(url: string): {
    encrypted: string | null;
    iv: string | null;
    authTag: string | null;
};
export declare function decryptProxyUrl(row: Partial<EncryptedProxyColumns> | undefined | null): string;
export declare function maskProxyUrl(url: string): string;
