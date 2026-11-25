// A stand-in OpenAI-compatible provider: fixed, deterministic replies.
import http from 'node:http';
const port = Number(process.argv[2] ?? 4599);
http.createServer((req, res) => {
  let body = '';
  req.on('data', (c) => { body += c; });
  req.on('end', () => {
    if (req.url.endsWith('/models')) {
      res.writeHead(200, { 'content-type': 'application/json' });
      res.end(JSON.stringify({ object: 'list', data: [{ id: 'mock-1', object: 'model' }] }));
      return;
    }
    let stream = false;
    try { stream = JSON.parse(body).stream === true; } catch {}
    if (stream) {
      res.writeHead(200, { 'content-type': 'text/event-stream' });
      for (const w of ['Hello', ' from', ' the', ' mock']) {
        res.write(`data: ${JSON.stringify({ id: 'c1', object: 'chat.completion.chunk', created: 1, model: 'mock-1', choices: [{ index: 0, delta: { content: w }, finish_reason: null }] })}\n\n`);
      }
      res.write(`data: ${JSON.stringify({ id: 'c1', object: 'chat.completion.chunk', created: 1, model: 'mock-1', choices: [{ index: 0, delta: {}, finish_reason: 'stop' }], usage: { prompt_tokens: 12, completion_tokens: 4, total_tokens: 16 } })}\n\n`);
      res.end('data: [DONE]\n\n');
      return;
    }
    res.writeHead(200, { 'content-type': 'application/json' });
    res.end(JSON.stringify({ id: 'c1', object: 'chat.completion', created: 1, model: 'mock-1',
      choices: [{ index: 0, message: { role: 'assistant', content: 'Hello from the mock' }, finish_reason: 'stop' }],
      usage: { prompt_tokens: 12, completion_tokens: 4, total_tokens: 16 } }));
  });
}).listen(port, '127.0.0.1', () => console.log('mock listening', port));
