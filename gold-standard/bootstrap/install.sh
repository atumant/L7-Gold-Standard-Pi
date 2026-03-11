#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PHASE="${1:-all}"
OUT_DIR=""

usage() {
  cat <<'EOF'
Gold Standard bootstrap

Usage:
  bootstrap/install.sh [all|preflight|facts|packages|render|configs|verify|savepoint]

Phases:
  preflight  - validate OS, privileges, network tools, and directories
  facts      - capture reusable host facts into rendered/facts
  packages   - install required packages (placeholder for staged package actions)
  render     - render env-driven output files into rendered/
  configs    - stage config files and print manual/apply guidance
  verify     - run verification checks
  savepoint  - capture a dated save point
  all        - run preflight, facts, packages, render, configs, verify, savepoint
EOF
}

init_run() {
  OUT_DIR="$($ROOT/bootstrap/run-manifest.sh)"
  export OUT_DIR
  echo "Run output: $OUT_DIR"
}

run_preflight() {
  "$ROOT/bootstrap/run-phase.sh" preflight "$ROOT/bootstrap/preflight.sh"
}

run_facts() {
  "$ROOT/bootstrap/run-phase.sh" facts "$ROOT/bootstrap/facts.sh"
}

run_packages() {
  "$ROOT/bootstrap/run-phase.sh" packages "$ROOT/bootstrap/packages.sh"
}

run_render() {
  "$ROOT/bootstrap/run-phase.sh" render "$ROOT/bootstrap/render.sh"
}

run_configs() {
  "$ROOT/bootstrap/run-phase.sh" configs "$ROOT/bootstrap/stage-configs.sh"
}

run_verify() {
  "$ROOT/bootstrap/run-phase.sh" verify "$ROOT/bootstrap/verify.sh"
}

run_savepoint() {
  "$ROOT/bootstrap/run-phase.sh" savepoint "$ROOT/scripts/capture-savepoint.sh"
}

case "$PHASE" in
  preflight) init_run; run_preflight ;;
  facts) init_run; run_facts ;;
  packages) init_run; run_packages ;;
  render) init_run; run_render ;;
  configs) init_run; run_configs ;;
  verify) init_run; run_verify ;;
  savepoint) init_run; run_savepoint ;;
  all)
    init_run
    run_preflight
    run_facts
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
