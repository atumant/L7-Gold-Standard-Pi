#!/usr/bin/env bash
set -euo pipefail
MODE="${1:-plan}"
"$(dirname "$0")/packages-auto.sh" "$MODE"
