#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PHASE="${1:-all}"

usage() {
  cat <<'EOF'
Gold Standard bootstrap

Usage:
  bootstrap/install.sh [all|preflight|packages|render|configs|verify|savepoint]

Phases:
  preflight  - validate OS, privileges, network tools, and directories
  packages   - install required packages (placeholder for staged package actions)
  render     - render env-driven output files into rendered/
  configs    - stage config files and print manual/apply guidance
  verify     - run verification checks
  savepoint  - capture a dated save point
  all        - run preflight, packages, render, configs, verify, savepoint
EOF
}

run_preflight() {
  "$ROOT/bootstrap/preflight.sh"
}

run_packages() {
  "$ROOT/bootstrap/packages.sh"
}

run_render() {
  "$ROOT/bootstrap/render.sh"
}

run_configs() {
  "$ROOT/bootstrap/stage-configs.sh"
}

run_verify() {
  "$ROOT/bootstrap/verify.sh"
}

run_savepoint() {
  "$ROOT/scripts/capture-savepoint.sh"
}

case "$PHASE" in
  preflight) run_preflight ;;
  packages) run_packages ;;
  render) run_render ;;
  configs) run_configs ;;
  verify) run_verify ;;
  savepoint) run_savepoint ;;
  all)
    run_preflight
    run_packages
    run_render
    run_configs
    run_verify
    run_savepoint
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    echo "Unknown phase: $PHASE" >&2
    usage >&2
    exit 1
    ;;
esac
