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
RUN_OUT="$(./bootstrap/run-manifest.sh)"
export OUT_DIR="$RUN_OUT"
./bootstrap/run-phase.sh render ./bootstrap/render.sh
./bootstrap/run-phase.sh apply-firewall ./bootstrap/apply.sh
./bootstrap/run-phase.sh verify-firewall ./bootstrap/verify.sh
./bootstrap/run-phase.sh apply-ssh ./bootstrap/apply-ssh.sh
./bootstrap/run-phase.sh verify-ssh ./bootstrap/verify.sh
./bootstrap/run-phase.sh apply-services ./bootstrap/apply-services.sh
./bootstrap/run-phase.sh verify-services ./bootstrap/verify.sh
./bootstrap/run-phase.sh savepoint ./scripts/capture-savepoint.sh
./scripts/archive-output.sh "$RUN_OUT" >/dev/null 2>&1 || true
