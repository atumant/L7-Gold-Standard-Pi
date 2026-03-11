#!/usr/bin/env bash
set -euo pipefail
REPO_URL="${REPO_URL:-https://github.com/atumant/L7-Gold-Standard-Pi.git}"
REF="${REF:-main}"
TMPDIR="${TMPDIR:-$(mktemp -d)}"
ARCHIVE_URL="${ARCHIVE_URL:-https://github.com/atumant/L7-Gold-Standard-Pi/archive/refs/heads/${REF}.tar.gz}"

cleanup() {
  rm -rf "$TMPDIR"
}
trap cleanup EXIT

echo "Fetching: $ARCHIVE_URL"
curl -fsSL "$ARCHIVE_URL" -o "$TMPDIR/repo.tar.gz"
mkdir -p "$TMPDIR/src"
tar -xzf "$TMPDIR/repo.tar.gz" -C "$TMPDIR/src"
ROOT_DIR="$(find "$TMPDIR/src" -mindepth 1 -maxdepth 1 -type d | head -n1)"
[ -n "$ROOT_DIR" ] || { echo 'Failed to locate extracted repo root' >&2; exit 1; }
TARGET="$ROOT_DIR/gold-standard"
[ -d "$TARGET" ] || { echo 'gold-standard directory missing in fetched repo' >&2; exit 1; }

echo "Fetched bootstrap to: $TARGET"
echo "Next steps:"
echo "  cd '$TARGET'"
echo "  ./bootstrap/install.sh preflight"
echo "  ./bootstrap/install.sh render"
