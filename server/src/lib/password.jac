import from "crypto" { default as crypto }

# Node's scrypt, stored as `scrypt$<saltHex>$<hashHex>`.
def hashPassword(password: str) -> str {
    salt = crypto.randomBytes(16);
    digest = crypto.scryptSync(password, salt, 64);
    return "scrypt$" + salt.toString("hex") + "$" + digest.toString("hex");
}

def verifyPassword(password: str, stored: str) -> bool {
    parts = stored.split("$");
    if len(parts) != 3 or parts[0] != "scrypt" {
        return False;
    }
    expected = globalThis.Buffer.from(parts[2], "hex");
    try {
        actual = crypto.scryptSync(
            password, globalThis.Buffer.from(parts[1], "hex"), expected.length
        );
        return actual.length == expected.length and crypto.timingSafeEqual(actual, expected);
    } except Exception {
        return False;
    }
}
