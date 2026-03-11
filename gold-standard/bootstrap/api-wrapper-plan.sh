#!/usr/bin/env bash
set -euo pipefail
cat <<'EOF'
Future API wrapper plan

Suggested endpoints:
- POST /profiles
- POST /bootstrap/preflight
- POST /bootstrap/render
- POST /bootstrap/apply/firewall
- POST /bootstrap/apply/ssh
- POST /bootstrap/apply/services
- POST /bootstrap/savepoint
- GET  /bootstrap/status/:runId
- GET  /savepoints

The wrapper should call the local bootstrap scripts, store logs, and expose structured status for front-end tools such as Lovable.
EOF
