// pdiff.mjs <a.cpuprofile> <b.cpuprofile> <requests>: self time per function (by name and file stem), b minus a, per request.
import fs from 'node:fs';
const self = (f) => { const p = JSON.parse(fs.readFileSync(f)); const dt = {}; for (let i = 0; i < p.samples.length; i++) dt[p.samples[i]] = (dt[p.samples[i]] ?? 0) + (p.timeDeltas[i] ?? 0); const o = {}; for (const x of p.nodes) { const t = dt[x.id] ?? 0; const k = `${x.callFrame.functionName || '(anon)'} ${x.callFrame.url.replace(/.*\//, '').replace(/\.(ts|mjs|js)$/, '')}`; o[k] = (o[k] ?? 0) + t; } return o; };
const a = self(process.argv[2]), b = self(process.argv[3]), n = Number(process.argv[4]);
const keys = new Set([...Object.keys(a), ...Object.keys(b)]);
const rows = [...keys].map((k) => [k, ((b[k] ?? 0) - (a[k] ?? 0)) / n]).sort((x, y) => Math.abs(y[1]) - Math.abs(x[1]));
for (const [k, d] of rows.slice(0, 30)) console.log(`${d >= 0 ? '+' : ''}${d.toFixed(1).padStart(7)}us ${k}`);
