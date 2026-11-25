# The password-reset code: minted and logged by POST /api/auth/forgot-password,
# good for 15 minutes, replaced by the next one and cleared by a reset.
glob:priv code: any = createOneTimeCode(),
          mintedAtMs: float = 0.0;

# The account email is logged too: who forgot the password may have forgotten
# which email signs in (#1477), and who reads this log can reset it already.
def generateResetCode(accountEmail: any = None) -> str {
    minted: str = code.generate();
    mintedAtMs = globalThis.Date.now();
    lines = ["", "  Password-reset code: " + minted];
    if accountEmail {
        lines.append("  Account email: " + accountEmail);
    }
    for line in lines + ["  Enter this code on the reset form to set a new password.", ""] {
        globalThis.console.log(line);
    }
    return minted;
}

def getResetCode -> any {
    return code.get();
}

def clearResetCode {
    code.clear();
    mintedAtMs = 0.0;
}

def resetCodeMatches(provided: any) -> bool {
    if not mintedAtMs {
        return False;
    }
    if globalThis.Date.now() - mintedAtMs > 15 * 60 * 1000 {
        clearResetCode();
        return False;
    }
    return code.matches(provided);
}
