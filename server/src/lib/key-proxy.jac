# Per-key proxy override (#590). A proxy URL carries `user:pass@`, so it is
# stored as the key is, AES-256-GCM ciphertext, iv and tag; outside the DB it
# is a string, '' meaning no override.
type EncryptedProxyColumns = any;

glob KEY_PROXY_URL_ERROR: str = "proxyUrl must be a valid proxy URL using http, https, socks4, socks4a, socks5 or socks5h (e.g. socks5://user:pass@host:1080), or '' to clear it",
     KEY_PROXY_URL_MAX: int = 2048;

# '' or a URL with a host on a scheme the global proxy validator takes too.
def isValidKeyProxyUrl(url: str) -> bool {
    trimmed = url.strip();
    if not trimmed {
        return True;
    }
    try {
        parsed: any = new(globalThis.URL, trimmed);
    } except Exception {
        return False;
    }
    return len(trimmed) <= KEY_PROXY_URL_MAX
        and PROXY_SCHEMES.includes(parsed.protocol)
        and parsed.hostname != "";
}

def encryptProxyUrl(url: str) -> any {
    trimmed = url.strip();
    if not trimmed {
        return plain(encrypted=NULL, iv=NULL, authTag=NULL);
    }
    sealed: any = encrypt(trimmed);
    return plain(encrypted=sealed.encrypted, iv=sealed.iv, authTag=sealed.authTag);
}

# '' also for a row that no longer decrypts (another ENCRYPTION_KEY): the
# request falls back to the global proxy rather than fail.
def decryptProxyUrl(row: any = None) -> str {
    fields = [
        getattr(row, f, None) if row else None
        for f in ["proxy_encrypted", "proxy_iv", "proxy_auth_tag"]
    ];
    if not all(fields) {
        return "";
    }
    try {
        return decrypt(*fields).trim();
    } except Exception {
        globalThis.console.warn(
            "[proxy] A key's proxy override could not be decrypted — falling back to the global proxy.",
        );
        return "";
    }
}

# The URL with its password masked; the user name stays. The last '@' before
# the path ends the userinfo, so a password holding '@' is masked whole.
def maskProxyUrl(url: str) -> str {
    trimmed = url.strip();
    schemeEnd = trimmed.find("://");
    if schemeEnd < 0 {
        return sub(trimmed, ":[^:@]*@", ":***@");
    }
    (scheme, rest) = (trimmed[:schemeEnd + 3], trimmed[schemeEnd + 3:]);
    pathStart: int = globalThis.String.prototype.search.call(rest, rx("[/?#]"));
    (authority, tail) = (rest, "") if pathStart < 0 else (rest[:pathStart], rest[pathStart:]);
    at = authority.rfind("@");
    colon = authority[:at].find(":") if at >= 0 else -1;
    if colon < 0 {
        return trimmed;
    }
    return f"{scheme}{authority[:colon]}:***@{authority[at + 1:]}{tail}";
}
