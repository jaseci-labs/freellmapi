// micro.ts <server-dir> [filter]: per-call cost of the server's hot functions that the Jac rewrite touched.
import fs from 'node:fs';
import os from 'node:os';
const S = process.argv[2] + '/src/';
const filter = process.argv[3] ? new RegExp(process.argv[3]) : null;
const tmp = fs.mkdtempSync(`${os.tmpdir()}/flmicro-`);
process.env.FREEAPI_DB_PATH = `${tmp}/db.sqlite`;
process.env.ENCRYPTION_KEY = '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';
const db = await import(S + 'db/index.ts');
db.initDb(`${tmp}/db.sqlite`);
const rl = await import(S + 'lib/request-log.ts');
const at = await import(S + 'lib/attempt-trace.ts');
const sp = await import(S + 'lib/system-prompt.ts');
const sd = await import(S + 'lib/system-date.ts');
const sm = await import(S + 'lib/served-model.ts');
const tt = await import(S + 'lib/task-type.ts');
const oc = await import(S + 'lib/output-cap.ts');
const tb = await import(S + 'lib/ttfb-budget.ts');
const er = await import(S + 'lib/error-redaction.ts');
const gr = await import(S + 'lib/guardrails.ts');
const tv = await import(S + 'lib/tool-validate.ts');
const ad = await import(S + 'lib/anthropic-documents.ts');
const au = await import(S + 'services/auth.ts');
const cfg = await import(S + 'lib/config.ts');
const wd = await import(S + 'lib/wake-detect.ts');
const key = db.getUnifiedApiKey();
const user = au.createUser('micro@example.com', 'micro-password-123');
const token = au.createSession(user.userId);
const msgs = () => [{ role: 'system', content: 'Be brief.' }, { role: 'user', content: 'Say hello and explain ```js\nconst x = 1\n``` briefly.' }];
const route = { platform: 'custom', modelId: 'mock-1', contextWindow: 128000, endpointScope: 'http://127.0.0.1:4599/v1' };
const schema = { type: 'object', properties: { city: { type: 'string' }, days: { type: 'integer' } }, required: ['city'] };
const cases: [string, number, () => unknown][] = [
  ['logRequest', 3000, () => rl.logRequest('custom', 'mock-1', 1, 'success', 12, 4, 5, null, 3, null, null, 'http')],
  ['persistRequestAttempts', 3000, () => rl.persistRequestAttempts({ records: [{ ordinal: 0, platform: 'custom', modelId: 'mock-1', keyOrdinal: 0, keyLabel: 'mock', outcome: 'ok', startOffsetMs: 0, durationMs: 5, errorSummary: null }], lastRequestRowId: 1 })],
  ['runWithRequestTrace+note+get', 100000, () => at.runWithRequestTrace(at.newRequestTrace(), () => { at.getRequestTrace(); return 1; })],
  ['resolveAuth', 30000, () => sp.resolveAuth(key)],
  ['prependSystemPrompt', 100000, () => sp.prependSystemPrompt(msgs(), null)],
  ['maybeInjectSystemDate', 30000, () => sd.maybeInjectSystemDate(msgs(), {})],
  ['observeServedModel', 100000, () => sm.observeServedModel({ platform: 'custom', requestedModel: 'mock-1', servedModel: 'mock-1' })],
  ['deriveTaskType', 100000, () => tt.deriveTaskType(undefined, msgs())],
  ['routeOutputBudget', 100000, () => oc.routeOutputBudget(route, 30)],
  ['getEndpointTimeBudgetMs', 30000, () => tb.getEndpointTimeBudgetMs(30000, 'custom', 'http://127.0.0.1:4599/v1')],
  ['summarizeAttemptError', 100000, () => er.summarizeAttemptError('429 Too Many Requests: rate limit for key sk-abcdef1234567890 exceeded')],
  ['applyTokenBudget', 30000, () => gr.applyTokenBudget(30, 200)],
  ['newBreaker+recordFailure', 30000, () => gr.recordBreakerFailure(gr.newBreaker())],
  ['validateToolArguments', 30000, () => tv.validateToolArguments('weather', '{"city":"Paris","days":3}', schema)],
  ['stableStringify', 100000, () => tv.stableStringify({ b: [1, { d: 2, c: 3 }], a: 'x' })],
  ['convertDocumentBlock', 30000, () => ad.convertDocumentBlock({ type: 'document', source: { type: 'text', media_type: 'text/plain', data: 'hello world' }, title: 'Notes' })],
  ['validateSession', 30000, () => au.validateSession(token)],
  ['loadConfig', 30000, () => cfg.loadConfig()],
];
const out: Record<string, number> = {};
for (const [name, n, f] of cases) {
  if (filter && !filter.test(name)) continue;
  for (let i = 0; i < Math.min(n, 2000); i++) f();
  const t0 = process.hrtime.bigint();
  for (let i = 0; i < n; i++) f();
  out[name] = Number(process.hrtime.bigint() - t0) / n / 1000;
}
// A fingerprint of results, to compare behaviour across trees.
const fp = JSON.stringify([sp.prependSystemPrompt(msgs(), 'P'), sm.observeServedModel({ platform: 'custom', requestedModel: 'a/b', servedModel: 'c' }), tt.deriveTaskType(undefined, msgs()), oc.routeOutputBudget(route, 30), er.summarizeAttemptError('429 key sk-abcdef1234567890'), gr.applyTokenBudget(30, 200), tv.validateToolArguments('w', '{"days":"x"}', schema), tv.stableStringify({ b: [1, { d: 2, c: 3 }], a: 'x' }), ad.convertDocumentBlock({ type: 'document', source: { type: 'text', media_type: 'text/plain', data: 'hi' }, title: 'T' }), au.validateSession(token)?.email, cfg.loadConfig().port]);
console.log(JSON.stringify({ us: out, fp }));
fs.rmSync(tmp, { recursive: true, force: true });
process.exit(0);
