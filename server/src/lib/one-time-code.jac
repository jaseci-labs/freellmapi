import from "crypto" { default as crypto }

# Uppercase letters and digits without the look-alikes (I, O, 0, 1), so a code
# is easy to read from a terminal log and type by hand.
glob:priv ALPHABET: str = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

obj OneTimeCode {
    has current: any = NULL;

    def generate -> str {
        self.current = "".join([ALPHABET[b % len(ALPHABET)] for b in crypto.randomBytes(10)]);
        return self.current;
    }

    def get -> any {
        return self.current;
    }

    def clear {
        self.current = NULL;
    }

    # Constant-time, and false when no code is active.
    def matches(provided: any) -> bool {
        if not self.current or not isinstance(provided, str) {
            return False;
        }
        a = globalThis.Buffer.from(self.current);
        b = globalThis.Buffer.from(provided);
        return a.length == b.length and crypto.timingSafeEqual(a, b);
    }
}

def createOneTimeCode -> OneTimeCode {
    return OneTimeCode();
}
