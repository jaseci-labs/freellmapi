// busy.mjs <cpuprofile> <requests>: non-idle CPU per request, and its share in neojac's runtime and the Jac modules.
import fs from 'node:fs';
const p = JSON.parse(fs.readFileSync(process.argv[2])); const n = Number(process.argv[3]);
const dt = {}; for (let i = 0; i < p.samples.length; i++) dt[p.samples[i]] = (dt[p.samples[i]] ?? 0) + (p.timeDeltas[i] ?? 0);
let busy = 0, core = 0, jac = 0;
for (const x of p.nodes) { const t = dt[x.id] ?? 0; const f = x.callFrame; if (f.functionName === '(idle)' || f.functionName === '(program)') continue; busy += t; if (/@jac\/core\.js/.test(f.url)) core += t; else if (/\.jac\/server\/src\/.*\.mjs/.test(f.url)) jac += t; }
console.log(`busy ${(busy / n).toFixed(0)}us/req  core.js self ${(core / n).toFixed(0)}us/req  Jac modules self ${(jac / n).toFixed(0)}us/req`);
