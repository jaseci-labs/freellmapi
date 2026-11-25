// bench.mjs <rounds> [label=dir:port ...]: start-up and endpoint timings, servers alternated per round.
import { spawn, execFileSync } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';

const rounds = Number(process.argv[2] ?? 5);
const targets = process.argv.slice(3).map((a) => { const [label, dir, port] = a.split(/[=:]/); return { label, dir, port: Number(port) }; });
const HERE = new URL('.', import.meta.url).pathname;
const BSQL = process.env.BSQL ?? new URL('../node_modules/better-sqlite3', import.meta.url).pathname;
const results = {}; const outputs = {};
const median = (a) => { const s = [...a].sort((x, y) => x - y); const m = s.length >> 1; return s.length % 2 ? s[m] : (s[m - 1] + s[m]) / 2; };
const rec = (label, key, v) => { ((results[label] ??= {})[key] ??= []).push(v); };
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function startServer(t, data) {
  const t0 = performance.now();
  const p = spawn(`${HERE}run-server.sh`, [t.dir, String(t.port), data], { stdio: ['ignore', 'pipe', 'pipe'], detached: true });
  let log = ''; p.stdout.on('data', (d) => { log += d; }); p.stderr.on('data', (d) => { log += d; });
  for (;;) {
    try { const r = await fetch(`http://127.0.0.1:${t.port}/api/ping`); if (r.ok) { await r.text(); break; } } catch {}
    if (p.exitCode !== null) throw new Error(`server exited: ${log}`);
    await sleep(5);
  }
  return { p, ms: performance.now() - t0, log: () => log };
}
async function stop(s) {
  try { process.kill(-s.p.pid, 'SIGKILL'); } catch {}
  await new Promise((r) => (s.p.exitCode !== null ? r() : s.p.on('exit', r)));
}

function norm(text) {
  return text.replace(/"(firstRequestAt|avgLatencyMs|p50LatencyMs|p95LatencyMs|avgTtfbMs|execution_id|id|ts|timestamp|created_at|createdAt|lastUsedAt|updatedAt|token|lastChecked\w*|last_\w+)":("[^"]*"|\d+)/g, '"$1":"*"')
    .replace(/msg_[0-9a-f]+/g, 'msg_*').replace(/\d{4}-\d\d-\d\dT[\d:.]+Z/g, 'T').replace(/lat=\d+ms/g, '');
}

async function run(t, label, round) {
  const data = fs.mkdtempSync(`${os.tmpdir()}/flbench-`);
  const cold = await startServer(t, data);
  rec(label, 'startup cold (fresh DB) ms', cold.ms);
  const key = execFileSync(process.execPath, [`${HERE}getkey.cjs`, `${data}/db.sqlite`], { env: { ...process.env, BSQL } }).toString().trim();
  const base = `http://127.0.0.1:${t.port}`;
  const login = await (await fetch(`${base}/api/auth/login`, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ email: 'bench@example.com', password: 'bench-password-123' }) })).json();
  const chat = (stream) => ({ method: 'POST', headers: { authorization: `Bearer ${key}`, 'content-type': 'application/json' }, body: JSON.stringify({ model: 'auto', stream, messages: [{ role: 'system', content: 'Be brief.' }, { role: 'user', content: 'Say hello and explain ```js\nconst x = 1\n``` briefly.' }] }) });
  const dash = { headers: { authorization: `Bearer ${login.token}` } };
  const eps = [
    ['GET /api/ping', '/api/ping', {}, 400],
    ['GET /v1/models', '/v1/models', { headers: { authorization: `Bearer ${key}` } }, 300],
    ['POST /v1/chat/completions', '/v1/chat/completions', chat(false), 300],
    ['POST /v1/chat/completions stream', '/v1/chat/completions', chat(true), 300],
    ['POST /v1/messages', '/v1/messages', { method: 'POST', headers: { 'x-api-key': key, 'content-type': 'application/json' }, body: JSON.stringify({ model: 'auto', max_tokens: 200, system: 'Be brief.', messages: [{ role: 'user', content: 'hello' }] }) }, 300],
    ['GET /api/auth/me', '/api/auth/me', dash, 400],
    ['GET /api/models', '/api/models', dash, 200],
    ['GET /api/analytics/summary', '/api/analytics/summary', dash, 200],
    ['POST /api/auth/login', '/api/auth/login', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ email: 'bench@example.com', password: 'bench-password-123' }) }, 20],
  ];
  for (const [name, path, init, n] of eps) {
    for (let i = 0; i < 20 && i < n; i++) await (await fetch(base + path, init)).text();
    const t0 = performance.now();
    let last = '';
    for (let i = 0; i < n; i++) { const r = await fetch(base + path, init); last = `${r.status} ${await r.text()}`; }
    rec(label, `${name} us/req`, ((performance.now() - t0) * 1000) / n);
    if (round === 0) (outputs[name] ??= {})[label] = norm(last);
  }
  // Concurrent: 16 in flight, 1600 chat completions.
  {
    const t0 = performance.now(); let i = 0;
    await Promise.all(Array.from({ length: 16 }, async () => { while (i++ < 1600) await (await fetch(`${base}/v1/chat/completions`, chat(false))).text(); }));
    rec(label, 'chat x16 concurrent req/s', 1600 / ((performance.now() - t0) / 1000));
  }
  await stop(cold);
  const warm = await startServer(t, data);
  rec(label, 'startup warm (existing DB) ms', warm.ms);
  await stop(warm);
  fs.rmSync(data, { recursive: true, force: true });
}

for (let r = 0; r < rounds; r++) {
  const order = r % 2 ? [...targets].reverse() : targets; // alternate which side goes first
  for (const t of order) { process.stderr.write(`round ${r} ${t.label} load=${os.loadavg()[0].toFixed(1)}\n`); await run(t, t.label, r); }
}
const labels = targets.map((t) => t.label);
console.log(`| metric | ${labels.join(' | ')} | ${labels.slice(1).map((l) => `${l}/${labels[0]}`).join(' | ')} |`);
console.log(`|---|${labels.map(() => '---:').join('|')}|${labels.slice(1).map(() => '---:').join('|')}|`);
for (const k of Object.keys(results[labels[0]])) {
  const ms = labels.map((l) => median(results[l][k]));
  console.log(`| ${k} | ${ms.map((m) => m.toFixed(1)).join(' | ')} | ${ms.slice(1).map((m) => (m / ms[0]).toFixed(2) + 'x').join(' | ')} |`);
}
for (const [name, o] of Object.entries(outputs)) {
  const same = labels.every((l) => o[l] === o[labels[0]]);
  console.log(`output ${name}: ${same ? 'same' : 'DIFFERENT'}`);
  if (!same) for (const l of labels) console.log(`  ${l}: ${o[l].slice(0, 400)}`);
}
console.log(`load at end: ${os.loadavg().map((x) => x.toFixed(1)).join(' ')}`);
