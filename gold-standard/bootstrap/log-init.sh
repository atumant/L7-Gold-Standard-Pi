#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STAMP="$(date +%F_%H%M%S)"
OUT="$ROOT/output/$STAMP"
mkdir -p "$OUT"
printf 'timestamp=%s\n' "$(date --iso-8601=seconds)" > "$OUT/meta.txt"
echo "$OUT"
