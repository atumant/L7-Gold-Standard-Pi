#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT_ROOT="$ROOT/backup-exports"
STAMP="$(date +%F_%H%M%S)"
OUT="$OUT_ROOT/$STAMP"
mkdir -p "$OUT"
cp -a "$ROOT/docs" "$OUT/"
cp -a "$ROOT/bootstrap" "$OUT/"
cp -a "$ROOT/configs" "$OUT/"
cp -a "$ROOT/savepoints" "$OUT/"
find "$OUT" -type f -name '*.tar.gz' -size +20M -delete 2>/dev/null || true
echo "$OUT"
