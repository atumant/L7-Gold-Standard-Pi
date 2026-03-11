#!/usr/bin/env node
const http = require('http');
const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

const PORT = process.env.GOLD_STANDARD_API_PORT || 8787;
const ROOT = path.resolve(__dirname, '..');
const RUNS = new Map();

function json(res, code, payload) {
  res.writeHead(code, { 'content-type': 'application/json' });
  res.end(JSON.stringify(payload, null, 2));
}

function runCommand(name, cmd, args = []) {
  const id = `${Date.now()}-${Math.random().toString(36).slice(2,8)}`;
  const child = spawn(cmd, args, { cwd: ROOT, stdio: ['ignore', 'pipe', 'pipe'] });
  let out = '';
  let err = '';
  child.stdout.on('data', d => { out += d.toString(); });
  child.stderr.on('data', d => { err += d.toString(); });
  RUNS.set(id, { id, name, cmd, args, status: 'running', out: '', err: '' });
  child.on('close', code => {
    RUNS.set(id, { id, name, cmd, args, status: code === 0 ? 'ok' : 'error', code, out, err });
  });
  return id;
}

const server = http.createServer((req, res) => {
  if (req.method === 'GET' && req.url === '/health') return json(res, 200, { ok: true });
  if (req.method === 'GET' && req.url === '/runs') return json(res, 200, { runs: [...RUNS.values()] });
  if (req.method === 'POST' && req.url === '/bootstrap/preflight') {
    const id = runCommand('preflight', './bootstrap/install.sh', ['preflight']);
    return json(res, 202, { runId: id });
  }
  if (req.method === 'POST' && req.url === '/bootstrap/render') {
    const id = runCommand('render', './bootstrap/install.sh', ['render']);
    return json(res, 202, { runId: id });
  }
  if (req.method === 'POST' && req.url === '/bootstrap/verify') {
    const id = runCommand('verify', './bootstrap/install.sh', ['verify']);
    return json(res, 202, { runId: id });
  }
  const m = req.url && req.url.match(/^\/runs\/([^/]+)$/);
  if (req.method === 'GET' && m) {
    const run = RUNS.get(m[1]);
    return run ? json(res, 200, run) : json(res, 404, { error: 'not_found' });
  }
  return json(res, 404, { error: 'not_found' });
});

server.listen(PORT, () => {
  console.log(`gold-standard api wrapper listening on http://127.0.0.1:${PORT}`);
});
