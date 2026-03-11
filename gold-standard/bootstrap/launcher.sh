#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/atumant/L7-Gold-Standard-Pi.git}"
REF="${REF:-main}"
WORKDIR="${WORKDIR:-$(mktemp -d)}"

cat <<EOF
Gold Standard launcher scaffold
Repo: ${REPO_URL}
Ref: ${REF}
Workdir: ${WORKDIR}

Future behavior:
1. fetch pinned archive or clone ref
2. optionally verify checksum/signature
3. enter gold-standard/
4. run bootstrap/install.sh with requested phase/profile
EOF
