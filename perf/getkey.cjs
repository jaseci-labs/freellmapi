// getkey.cjs <db>: print the unified API key a fresh server stored.
const Database = require(process.env.BSQL);
const db = new Database(process.argv[2], { readonly: true });
console.log(db.prepare("SELECT value FROM settings WHERE key='unified_api_key'").get().value);
