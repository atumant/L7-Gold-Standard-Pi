#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
find "$ROOT/output" -mindepth 1 -maxdepth 1 -type d -mtime +7 -print -exec rm -rf {} + 2>/dev/null || true
find "$ROOT/archives" -mindepth 1 -maxdepth 1 -type f -name '*.tar.gz' -mtime +30 -print -delete 2>/dev/null || true
