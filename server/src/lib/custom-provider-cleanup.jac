# The api_keys rows of a custom endpoint nothing is registered against any
# more, removed after a custom model is deleted. The unit is the endpoint, not
# the key: an endpoint holds a pool of keys (#619), and a key with no model of
# its own is usually a spare for rotation (#702). A key with no base_url
# belongs to no pool and answers for itself.
glob:priv TABLES: list[str] = ["models", "embedding_models", "media_models"];

def deleteUnusedCustomEndpointKey(db: any, keyId: any = None) {
    if missing(keyId) {
        return;
    }
    row: any = db.prepare("SELECT base_url FROM api_keys WHERE id = ? AND platform = 'custom'").get(
        keyId
    );
    if row and row.base_url {
        if sum(
            db.prepare(
                f"SELECT COUNT(*) AS n FROM {table} m JOIN api_keys k ON k.id = m.key_id WHERE m.platform = 'custom' AND k.platform = 'custom' AND k.base_url = ?",
            ).get(row.base_url).n
            for table in TABLES,
        )
            == 0
        {
            db.prepare("DELETE FROM api_keys WHERE platform = 'custom' AND base_url = ?").run(
                row.base_url
            );
        }
    } elif sum(
        db.prepare(
            f"SELECT COUNT(*) AS n FROM {table} WHERE platform = 'custom' AND key_id = ?"
        ).get(keyId).n
        for table in TABLES,
    )
        == 0
    {
        db.prepare("DELETE FROM api_keys WHERE id = ? AND platform = 'custom'").run(keyId);
    }
}
