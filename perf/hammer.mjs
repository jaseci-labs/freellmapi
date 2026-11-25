// hammer.mjs <port> <db> <n>: n sequential chat completions.
import { execFileSync } from 'node:child_process';
const [port, db, n, mode = 'chat'] = process.argv.slice(2);
const key = execFileSync(process.execPath, [new URL('getkey.cjs', import.meta.url).pathname, db], { env: { ...process.env, BSQL: process.env.BSQL ?? new URL('../node_modules/better-sqlite3', import.meta.url).pathname } }).toString().trim();
const init = { method: 'POST', headers: { authorization: `Bearer ${key}`, 'content-type': 'application/json' }, body: JSON.stringify({ model: 'auto', messages: [{ role: 'system', content: 'Be brief.' }, { role: 'user', content: 'Say hello and explain ```js\nconst x = 1\n``` briefly.' }] }) };
const msgs = { method: 'POST', headers: { 'x-api-key': key, 'content-type': 'application/json' }, body: JSON.stringify({ model: 'auto', max_tokens: 200, system: 'Be brief.', messages: [{ role: 'user', content: 'hello' }] }) };
const stream = { ...init, body: init.body.replace('"model":"auto"', '"model":"auto","stream":true') };
const [path, req] = mode === 'messages' ? ['/v1/messages', msgs] : mode === 'stream' ? ['/v1/chat/completions', stream] : ['/v1/chat/completions', init];
const t0 = performance.now();
for (let i = 0; i < Number(n); i++) await (await fetch(`http://127.0.0.1:${port}${path}`, req)).text();
console.log(((performance.now() - t0) * 1000 / n).toFixed(0), 'us/req');
