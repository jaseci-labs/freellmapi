import from "express" { default as express }
import from "zod" { z }

# Client-profile CRUD (#411) under /api/client-profiles, behind the dashboard
# session. The full `sk-cp-...` key leaves the server only from create and
# rotate; the list shows the masked form, from the encrypted copy, since the
# auth path stores only a hash.
glob clientProfilesRouter: any = express.Router();

glob:priv name: any = z.string().trim().min(1).max(100),
          # A system prompt is configuration, not a document.
          prompt: any = z.string().max(32000),
          createSchema: any = z.object(plain(name=name, systemPrompt=prompt.nullish())),
          # null clears the prompt; absent leaves it.
          updateSchema: any = z.object(
              plain(
                  name=name.optional(),
                  systemPrompt=prompt.nullable().optional(),
                  enabled=z.boolean().optional(),
              ),
          );

def:priv fail(res: any, status: int, message: str) {
    res.status(status).json(plain(error=plain(message=message)));
}

def:priv toJson(row: any) -> any {
    try {
        masked: any = maskKey(decrypt(row.encrypted_key, row.iv, row.auth_tag));
    } except Exception {
        masked = "[decrypt failed]";
    }
    return plain(
        id=row.id,
        name=row.name,
        maskedKey=masked,
        systemPrompt=row.system_prompt,
        enabled=row.enabled == 1,
        createdAt=row.created_at,
        updatedAt=row.updated_at,
    );
}

def:priv getProfile(id: any) -> any {
    return getDb().prepare("SELECT * FROM client_profiles WHERE id = ?").get(id);
}

def:priv idOf(req: any, res: any) -> any {
    id: any = globalThis.Number(req.params.id);
    if globalThis.Number.isInteger(id) and id > 0 {
        return id;
    }
    fail(res, 400, "Invalid profile id");
    return None;
}

# The profile, or None once the response says why not.
def:priv profileOf(id: any, res: any) -> any {
    row: any = getProfile(id) if id is not None else None;
    if id is not None and not row {
        fail(res, 404, "Client profile not found");
    }
    return row or None;
}

def:priv clearedPrompt(value: any) -> any {
    return (value.trim() if isinstance(value, str) else "") or NULL;
}

# A fresh key, stored as its hash and its encrypted copy.
def:priv newKey -> tuple[str, any] {
    key: str = mintClientProfileKey();
    return (key, encrypt(key));
}

def:priv listAll(_req: any, res: any) {
    res.json([
        toJson(row)
        for row in getDb().prepare("SELECT * FROM client_profiles ORDER BY id").all()
    ]);
}

def:priv create(req: any, res: any) {
    parsed: any = createSchema.safeParse(req.body);
    if not parsed.success {
        fail(res, 400, "A profile name is required");
        return;
    }
    (key, sealed) = newKey();
    info: any = getDb().prepare(
        "INSERT INTO client_profiles (name, token_hash, encrypted_key, iv, auth_tag, system_prompt) VALUES (?, ?, ?, ?, ?, ?)",
    ).run(
        parsed.data.name,
        hashClientProfileKey(key),
        sealed.encrypted,
        sealed.iv,
        sealed.authTag,
        clearedPrompt(getattr(parsed.data, "systemPrompt", None)),
    );
    res.status(201).json(
        globalThis.Object.assign(toJson(getProfile(info.lastInsertRowid)), plain(key=key))
    );
}

def:priv update(req: any, res: any) {
    id = idOf(req, res);
    if id is None {
        return;
    }
    parsed: any = updateSchema.safeParse(req.body);
    if not parsed.success {
        fail(res, 400, "Invalid profile update");
        return;
    }
    row: any = profileOf(id, res);
    if row is None {
        return;
    }
    data: any = parsed.data;
    givenPrompt: any = getattr(data, "systemPrompt", None);
    enabled: any = getattr(data, "enabled", None);
    getDb().prepare(
        "UPDATE client_profiles SET name = ?, system_prompt = ?, enabled = ?, updated_at = datetime('now') WHERE id = ?",
    ).run(
        getattr(data, "name", None) ?? row.name,
        row.system_prompt if givenPrompt is None else clearedPrompt(givenPrompt),
        row.enabled if enabled is None else int(enabled),
        row.id,
    );
    res.json(toJson(getProfile(row.id)));
}

def:priv rotate(req: any, res: any) {
    row: any = profileOf(idOf(req, res), res);
    if row is None {
        return;
    }
    (key, sealed) = newKey();
    getDb().prepare(
        "UPDATE client_profiles SET token_hash = ?, encrypted_key = ?, iv = ?, auth_tag = ?, updated_at = datetime('now') WHERE id = ?",
    ).run(hashClientProfileKey(key), sealed.encrypted, sealed.iv, sealed.authTag, row.id);
    res.json(globalThis.Object.assign(toJson(getProfile(row.id)), plain(key=key)));
}

def:priv remove(req: any, res: any) {
    id = idOf(req, res);
    if id is not None
        and getDb().prepare("DELETE FROM client_profiles WHERE id = ?").run(id).changes == 0
    {
        fail(res, 404, "Client profile not found");
    } elif id is not None {
        res.json(plain(success=True));
    }
}

with entry {
    clientProfilesRouter.get("/", listAll);
    clientProfilesRouter.post("/", create);
    clientProfilesRouter.patch("/:id", update);
    clientProfilesRouter.post("/:id/rotate", rotate);
    clientProfilesRouter.delete("/:id", remove);
}
