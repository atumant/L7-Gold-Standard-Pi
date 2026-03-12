#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PHASE="${1:-all}"
OUT_DIR=""
OPENCLAW_MODE="${OPENCLAW_MODE:-plan}"

usage() {
  cat <<'EOF'
Gold Standard bootstrap

Usage:
  bootstrap/install.sh [all|preflight|facts|packages|render|configs|openclaw|openclaw-apply|openclaw-verify|verify|savepoint|cloud]

Phases:
  preflight       - validate OS, privileges, network tools, and directories
  facts           - capture reusable host facts into rendered/facts
  packages        - install required packages (plan mode via orchestrator)
  render          - render env-driven output files into rendered/
  configs         - stage config files and print manual/apply guidance
  openclaw        - plan OpenClaw install/config automation
  openclaw-apply  - install/apply OpenClaw config automation
  openclaw-verify - verify OpenClaw status after config/apply
  verify          - run verification checks
  savepoint       - capture a dated save point
  cloud           - run cloud-profile branching guidance
  all             - run preflight, facts, packages, render, configs, openclaw, verify, savepoint
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
  "$ROOT/bootstrap/run-phase.sh" packages "$ROOT/bootstrap/packages.sh" plan
}

run_render() {
  "$ROOT/bootstrap/run-phase.sh" render "$ROOT/bootstrap/render.sh"
}

run_configs() {
  "$ROOT/bootstrap/run-phase.sh" configs "$ROOT/bootstrap/stage-configs.sh"
}

run_openclaw_plan() {
  "$ROOT/bootstrap/run-phase.sh" openclaw-install "$ROOT/bootstrap/openclaw-install.sh" plan
  "$ROOT/bootstrap/run-phase.sh" openclaw-config "$ROOT/bootstrap/openclaw-apply-config.sh" plan
}

run_openclaw_apply() {
  "$ROOT/bootstrap/run-phase.sh" openclaw-install "$ROOT/bootstrap/openclaw-install.sh" apply
  "$ROOT/bootstrap/run-phase.sh" openclaw-config "$ROOT/bootstrap/openclaw-apply-config.sh" apply
}

run_openclaw_verify() {
  "$ROOT/bootstrap/run-phase.sh" openclaw-install-verify "$ROOT/bootstrap/openclaw-install.sh" verify
  "$ROOT/bootstrap/run-phase.sh" openclaw-config-verify "$ROOT/bootstrap/openclaw-apply-config.sh" verify
}

run_cloud() {
  "$ROOT/bootstrap/run-phase.sh" cloud "$ROOT/bootstrap/cloud-branch.sh"
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
  openclaw) init_run; run_openclaw_plan ;;
  openclaw-apply) init_run; run_openclaw_apply ;;
  openclaw-verify) init_run; run_openclaw_verify ;;
  cloud) init_run; run_cloud ;;
  verify) init_run; run_verify ;;
  savepoint) init_run; run_savepoint ;;
  all)
    init_run
    run_preflight
    run_facts
    run_packages
    run_render
    run_configs
    run_openclaw_plan
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
