// startup.mjs <rounds> label=dir ...: wall time from spawn to the first /api/ping, existing DB, servers alternated.
import { spawn } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
const rounds = Number(process.argv[2]);
const targets = process.argv.slice(3).map((a) => { const [label, dir] = a.split('='); return { label, dir }; });
const HERE = new URL('.', import.meta.url).pathname;
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const res = {};
async function once(t, data, port) {
  const t0 = performance.now();
  const p = spawn(`${HERE}run-server.sh`, [t.dir, String(port), data], { stdio: 'ignore', detached: true });
  for (;;) { try { const r = await fetch(`http://127.0.0.1:${port}/api/ping`); if (r.ok) { await r.text(); break; } } catch {} await sleep(2); }
  const ms = performance.now() - t0;
  process.kill(-p.pid, 'SIGKILL'); await new Promise((r) => (p.exitCode !== null || p.signalCode ? r() : p.on('exit', r)));
  return ms;
}
const dirs = {};
for (const t of targets) { dirs[t.label] = fs.mkdtempSync(`${os.tmpdir()}/flstart-`); await once(t, dirs[t.label], 4610); }
for (let r = 0; r < rounds; r++) for (const t of (r % 2 ? [...targets].reverse() : targets)) (res[t.label] ??= []).push(await once(t, dirs[t.label], 4610));
const med = (a) => { const s = [...a].sort((x, y) => x - y); return s[s.length >> 1]; };
for (const t of targets) console.log(t.label, 'median', med(res[t.label]).toFixed(0), 'ms', 'min', Math.min(...res[t.label]).toFixed(0), 'all', res[t.label].map((x) => x.toFixed(0)).join(' '));
console.log('load', os.loadavg().map((x) => x.toFixed(1)).join(' '));
