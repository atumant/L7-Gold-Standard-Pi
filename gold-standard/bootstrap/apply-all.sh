#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APPLY_APPROVE="${AUTO_APPROVE:-}"

cat <<'EOF'
Staged full-apply sequence:
1. render current profile
2. stage configs
3. apply OpenClaw config
4. apply firewall
5. verify access
6. apply SSH snippets
7. verify access again
8. apply service minimization
9. verify services/listeners
10. capture save point
EOF

echo
ans="$APPLY_APPROVE"
if [ -z "$ans" ]; then
  read -r -p "Run staged render + OpenClaw + firewall + SSH + services sequence? [y/N] " ans
fi
if [[ ! "$ans" =~ ^([Yy]|yes|YES|true|TRUE|1)$ ]]; then
  echo 'Skipped.'
  exit 0
fi

cd "$ROOT"
RUN_OUT="$(./bootstrap/run-manifest.sh)"
export OUT_DIR="$RUN_OUT"
export AUTO_APPROVE="${AUTO_APPROVE:-yes}"
./bootstrap/run-phase.sh render ./bootstrap/render.sh
./bootstrap/run-phase.sh configs ./bootstrap/stage-configs.sh
./bootstrap/run-phase.sh openclaw-apply ./bootstrap/openclaw-apply-config.sh apply
./bootstrap/run-phase.sh apply-firewall ./bootstrap/apply.sh
./bootstrap/run-phase.sh verify-firewall ./bootstrap/verify.sh
./bootstrap/run-phase.sh apply-ssh ./bootstrap/apply-ssh.sh
./bootstrap/run-phase.sh verify-ssh ./bootstrap/verify.sh
./bootstrap/run-phase.sh apply-services ./bootstrap/apply-services.sh
./bootstrap/run-phase.sh verify-services ./bootstrap/verify.sh
./bootstrap/run-phase.sh savepoint ./scripts/capture-savepoint.sh
./scripts/archive-output.sh "$RUN_OUT" >/dev/null 2>&1 || true

echo "Completed staged apply flow. Output: $RUN_OUT"
