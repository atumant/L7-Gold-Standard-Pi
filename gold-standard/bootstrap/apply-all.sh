#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cat <<'EOF'
Staged full-apply sequence:
1. render current profile
2. apply firewall
3. verify access
4. apply SSH snippets
5. verify access again
6. apply service minimization
7. verify services/listeners
8. capture save point
EOF

echo
read -r -p "Run staged render + firewall + SSH + services sequence? [y/N] " ans
if [[ ! "$ans" =~ ^[Yy]$ ]]; then
  echo 'Skipped.'
  exit 0
fi

cd "$ROOT"
./bootstrap/install.sh render
./bootstrap/apply.sh
./bootstrap/verify.sh
./bootstrap/apply-ssh.sh
./bootstrap/verify.sh
./bootstrap/apply-services.sh
./bootstrap/verify.sh
./scripts/capture-savepoint.sh
