#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT_ROOT="$ROOT/output"
ARCHIVE_ROOT="$ROOT/archives"
mkdir -p "$ARCHIVE_ROOT"
latest="${1:-}"
if [ -z "$latest" ]; then
  latest="$(find "$OUT_ROOT" -mindepth 1 -maxdepth 1 -type d | sort | tail -n 1)"
fi
[ -n "$latest" ] || { echo 'No output directory found' >&2; exit 1; }
[ -d "$latest" ] || latest="$OUT_ROOT/$latest"
[ -d "$latest" ] || { echo "Output dir not found: $latest" >&2; exit 1; }
base="$(basename "$latest")"
archive="$ARCHIVE_ROOT/${base}.tar.gz"
tar -C "$OUT_ROOT" -czf "$archive" "$base"
echo "$archive"
