import from "fs" { default as fs }
import from "path" { default as path }
import from "node:process" { default as process }
import from "node:child_process" { execFileSync }

# Restricts a sensitive file (encrypted provider keys, the password hash, the
# master key) to its owner. POSIX gets chmod 0600. On Windows chmod is a
# silent no-op and a file keeps the ACL it inherited, so inheritance is
# dropped and the ACL rewritten to the user, SYSTEM and Administrators, as
# 0600 never locks root out either. A directory covers files not created yet
# (SQLite's -wal and -shm): Windows hands its (OI)(CI) ACEs down, and on POSIX
# 0700 makes the children unreachable rather than unreadable.
type ExecFileSyncLike = any;

type RestrictOptions = any;

# By SID, since the display names are localized.
glob:priv SID_SYSTEM: str = "S-1-5-18",
          SID_ADMINISTRATORS: str = "S-1-5-32-544",
          # A directory keeps its search bit, or the process locks itself out.
          POSIX_MODE: dict[str, int] = {"file": 0o600, "directory": 0o700},
          SID: any = rx("\x22(S-1-[0-9-]+)\x22"),
          ownerSidCache: any = None,
          ownerSidKnown: bool = False;

def:priv option(opts: any, name: str) -> any {
    return getattr(opts, name, None) if opts else None;
}

def:priv execOptions -> any {
    return plain(encoding="utf8", timeout=5000, windowsHide=True, stdio=["ignore", "pipe", "pipe"]);
}

# Never off PATH: an MSYS whoami shadows Windows', and PATH choosing the
# binary that hardens a file is itself a hijack vector.
def:priv system32(binary: str) -> str {
    return path.join(process.env.SystemRoot ?? "C:\\Windows", "System32", binary);
}

# Memoized only for the real binary, so a test's fake is never cached.
def:priv resolveOwnerSid(exec: any, useCache: bool) -> any {
    if useCache and ownerSidKnown {
        return ownerSidCache;
    }
    try {
        found: any = SID.exec(
            exec(system32("whoami.exe"), ["/user", "/fo", "csv", "/nh"], execOptions())
        );
        sid: any = found[1] if found else NULL;
    } except Exception {
        sid = NULL;
    }
    if useCache {
        (ownerSidCache, ownerSidKnown) = (sid, True);
    }
    return sid;
}

# /inheritance:r drops the inherited ACEs; /grant:r replaces, so a second run
# changes nothing; `*` reads each principal as a SID. (OI)(CI) only for a
# directory, which is what hands it down.
def windowsRestrictArgs(target: str, ownerSid: str, opts: any = None) -> list[str] {
    rights = "(OI)(CI)(F)" if option(opts, "inheritable") else "(F)";
    args = [target, "/inheritance:r"];
    for sid in [ownerSid, SID_SYSTEM, SID_ADMINISTRATORS] {
        args += ["/grant:r", f"*{sid}:{rights}"];
    }
    return args;
}

def:priv restrict(target: str, kind: str, opts: any = None) -> bool {
    exec: any = option(opts, "execFileSync") or execFileSync;
    try {
        if not fs.existsSync(target) {
            return True;
        }
        if (option(opts, "platform") or process.platform) != "win32" {
            fs.chmodSync(target, POSIX_MODE[kind]);
            return True;
        }
        ownerSid: any = option(opts, "ownerSid");
        if ownerSid is None {
            ownerSid = resolveOwnerSid(exec, option(opts, "execFileSync") is None);
        }
        if not ownerSid {
            return False;
        }
        exec(
            system32("icacls.exe"),
            windowsRestrictArgs(target, ownerSid, plain(inheritable=kind == "directory")),
            execOptions(),
        );
        return True;
    } except Exception {
        return False;
    }
}

# Never throws: permissions harden, they are not correctness, and startup must
# survive a filesystem that cannot express them. False is for the caller to
# report: what made this necessary was a guard everyone believed ran.
def restrictToOwner(target: str, opts: any = None) -> bool {
    return restrict(target, "file", opts);
}

# Only for a directory that is certainly this process's own: locking down a
# shared one is a worse outage than the leak it prevents.
def restrictDirToOwner(target: str, opts: any = None) -> bool {
    return restrict(target, "directory", opts);
}

# Resolves the SID once for all the targets; a missing file is skipped.
def restrictAllToOwner(targets: list[str], opts: any = None) -> list[str] {
    exec: any = option(opts, "execFileSync") or execFileSync;
    platform: any = option(opts, "platform") or process.platform;
    ownerSid: any = option(opts, "ownerSid");
    if platform == "win32" and ownerSid is None {
        ownerSid = resolveOwnerSid(exec, option(opts, "execFileSync") is None);
    }
    shared = plain(
        execFileSync=option(opts, "execFileSync"),
        platform=platform,
        ownerSid=NULL if ownerSid is None else ownerSid,
    );
    return [target for target in targets if not restrictToOwner(target, shared)];
}
