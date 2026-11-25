import from "crypto" { default as crypto }

# Dashboard authentication (#35): email and password accounts with opaque
# session tokens, gating /api/*. The unified API key, which gates /v1, is apart.
type AuthSource = any;

type SessionUser = any;

glob OIDC_REAUTH_WINDOW_MS: int = 5 * 60 * 1000,
     # Wrong passwords in a row, against a signed-in session, before it ends
     # (#1885): a stolen token must not be an unlimited password oracle.
     MAX_REAUTH_STRIKES: int = 3;

glob:priv SESSION_TTL_MS: int = 30 * 24 * 60 * 60 * 1000,
          reauthStrikes: dict[int, int] = {};

def:priv sessionUser(
    userId: any, email: str, authSource: str = "password", reauthenticatedAtMs: any = NULL
) -> any {
    return plain(
        userId=userId,
        email=email,
        authSource=authSource,
        hasLocalPassword=authSource == "password",
        reauthenticatedAtMs=reauthenticatedAtMs,
    );
}

def:priv emailTaken(db: any, email: str, exceptId: int = -1) {
    if db.prepare("SELECT id FROM users WHERE email = ? AND id != ?").get(email, exceptId) {
        err: any = new(globalThis.Error, "An account with that email already exists");
        err.code = "email_taken";
        raise err;
    }
}

def:priv localPasswordMatches(db: any, userId: int, password: str) -> bool {
    row: any = db.prepare("SELECT password_hash, has_local_password FROM users WHERE id = ?").get(
        userId
    );
    return bool(row)
        and row.has_local_password != 0
        and verifyPassword(password, row.password_hash);
}

def hashSessionToken(s: str) -> str {
    return crypto.createHash("sha256").update(s).digest("hex");
}

def isSessionRecentlyReauthenticated(session: any, now: any = None) -> bool {
    at: any = session.reauthenticatedAtMs;
    return session.authSource == "oidc"
        and not missing(at)
        and (now ?? globalThis.Date.now()) - at <= OIDC_REAUTH_WINDOW_MS;
}

def sessionReauthenticatedUntilMs(session: any, now: any = None) -> any {
    return session.reauthenticatedAtMs + OIDC_REAUTH_WINDOW_MS
        if isSessionRecentlyReauthenticated(session, now)
        else NULL;
}

# The one spelling the DB is keyed on; the login throttle buckets by it too, so
# a padded address cannot land in a bucket of its own.
def normalizeEmail(email: str) -> str {
    return email.strip().lower();
}

def userCount -> int {
    return getDb().prepare("SELECT COUNT(*) AS c FROM users").get().c;
}

# Throws { code: 'email_taken' } where the address is in use.
def createUser(email: str, password: str) -> any {
    db: any = getDb();
    normalized = normalizeEmail(email);
    emailTaken(db, normalized);
    result: any = db.prepare(
        "INSERT INTO users (email, password_hash, has_local_password) VALUES (?, ?, 1)"
    ).run(normalized, hashPassword(password));
    return sessionUser(globalThis.Number(result.lastInsertRowid), normalized);
}

# Provisioned by OIDC (#2008): an unusable random hash keeps NOT NULL, and
# has_local_password=0 blocks password sign-in.
def createPasswordlessUser(email: str) -> any {
    db: any = getDb();
    normalized = normalizeEmail(email);
    emailTaken(db, normalized);
    result: any = db.prepare(
        "INSERT INTO users (email, password_hash, has_local_password) VALUES (?, ?, 0)"
    ).run(normalized, hashPassword(crypto.randomBytes(32).toString("hex")));
    return sessionUser(globalThis.Number(result.lastInsertRowid), normalized, "oidc");
}

def verifyCredentials(email: str, password: str) -> any {
    row: any = getDb().prepare("SELECT id, email FROM users WHERE email = ?").get(
        normalizeEmail(email)
    );
    return sessionUser(row.id, row.email)
        if row and localPasswordMatches(getDb(), row.id, password)
        else NULL;
}

# The desktop app's session, making the hidden desktop@localhost account, with
# a password nobody knows, on first run.
def desktopSessionToken -> str {
    if userCount() == 0 {
        createUser("desktop@localhost", crypto.randomBytes(24).toString("hex"));
    }
    return createSession(
        getDb().prepare("SELECT id FROM users ORDER BY id ASC LIMIT 1").get().id, "desktop"
    );
}

# Only the token's hash is stored.
def createSession(userId: int, authSource: str = "password") -> str {
    token: str = crypto.randomBytes(32).toString("hex");
    getDb().prepare(
        "INSERT INTO sessions (token_hash, user_id, expires_at_ms, auth_source) VALUES (?, ?, ?, ?)"
    ).run(hashSessionToken(token), userId, globalThis.Date.now() + SESSION_TTL_MS, authSource);
    return token;
}

def stampSessionReauthenticated(tokenHash: str, now: any = None) -> bool {
    at = now ?? globalThis.Date.now();
    return getDb().prepare(
        "UPDATE sessions SET reauthenticated_at_ms = ? WHERE token_hash = ? AND expires_at_ms > ?"
    ).run(at, tokenHash, at).changes
        > 0;
}

def validateSession(token: any = None) -> any {
    if not token {
        return NULL;
    }
    db: any = getDb();
    row: any = db.prepare(
        "SELECT s.user_id, s.expires_at_ms, s.auth_source, s.reauthenticated_at_ms, u.email, u.has_local_password FROM sessions s JOIN users u ON u.id = s.user_id WHERE s.token_hash = ?",
    ).get(hashSessionToken(token));
    if not row {
        return NULL;
    }
    if row.expires_at_ms < globalThis.Date.now() {
        deleteSession(token);
        return NULL;
    }
    user: any = sessionUser(
        row.user_id,
        row.email,
        row.auth_source if row.auth_source in ["oidc", "desktop"] else "password",
        NULL if missing(row.reauthenticated_at_ms) else row.reauthenticated_at_ms,
    );
    user.hasLocalPassword = row.has_local_password != 0;
    return user;
}

def deleteSession(token: any = None) {
    if token {
        getDb().prepare("DELETE FROM sessions WHERE token_hash = ?").run(hashSessionToken(token));
    }
}

# True when this strike ended the session; then login's per-email lockout applies.
def recordReauthFailure(userId: int, token: any = None) -> bool {
    strikes = reauthStrikes.get(userId, 0) + 1;
    if strikes >= MAX_REAUTH_STRIKES {
        reauthStrikes.pop(userId, None);
        deleteSession(token);
        return True;
    }
    reauthStrikes[userId] = strikes;
    return False;
}

def clearReauthFailures(userId: int) {
    reauthStrikes.pop(userId, None);
}

def resetReauthFailures {
    reauthStrikes.clear();
}

# Sessions stay alive; the next validateSession reads the new address.
def updateEmail(userId: int, currentPassword: str, newEmail: str) -> bool {
    db: any = getDb();
    if not localPasswordMatches(db, userId, currentPassword) {
        return False;
    }
    normalized = normalizeEmail(newEmail);
    emailTaken(db, normalized, userId);
    db.prepare("UPDATE users SET email = ? WHERE id = ?").run(normalized, userId);
    return True;
}

# Ends every session of the user.
def updatePassword(userId: int, currentPassword: str, newPassword: str) -> bool {
    db: any = getDb();
    if not localPasswordMatches(db, userId, currentPassword) {
        return False;
    }
    db.prepare("UPDATE users SET password_hash = ? WHERE id = ?").run(
        hashPassword(newPassword), userId
    );
    db.prepare("DELETE FROM sessions WHERE user_id = ?").run(userId);
    return True;
}

def accountEmail -> any {
    row: any = getDb().prepare("SELECT email FROM users LIMIT 1").get();
    return row.email if row else NULL;
}

# Resets the only user's password and ends its sessions, restoring
# has_local_password so the logged reset code stays a recovery hatch for an
# OIDC-only install.
def resetUserPassword(newPassword: str) -> any {
    db: any = getDb();
    row: any = db.prepare("SELECT id, email FROM users LIMIT 1").get();
    if not row {
        return NULL;
    }
    db.prepare("UPDATE users SET password_hash = ?, has_local_password = 1 WHERE id = ?").run(
        hashPassword(newPassword), row.id
    );
    db.prepare("DELETE FROM sessions WHERE user_id = ?").run(row.id);
    return sessionUser(row.id, row.email);
}
