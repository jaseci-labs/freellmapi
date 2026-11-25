# The first-run setup code. POST /api/auth/setup makes the first admin while
# there are no users, and the server binds every interface, so a request from
# anywhere but this machine must present the code minted and logged at boot.
glob:priv code: any = createOneTimeCode();

def generateSetupCode -> str {
    minted: str = code.generate();
    for line in [
        "",
        "  First-run setup code: " + minted,
        "  A browser on this machine can finish setup without it. From any",
        "  other device, enter this code to create the first account.",
        "",
    ] {
        globalThis.console.log(line);
    }
    return minted;
}

def getSetupCode -> any {
    return code.get();
}

def clearSetupCode {
    code.clear();
}

def setupCodeMatches(provided: any) -> bool {
    return code.matches(provided);
}
