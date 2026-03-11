#!/usr/bin/env bash
set -euo pipefail
OS="unknown"
FAMILY="unknown"
PLATFORM="unknown"
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS="${ID:-unknown}"
  FAMILY="linux"
  case "${ID:-unknown}" in
    debian|raspbian|ubuntu) PLATFORM="debian-like" ;;
    *) PLATFORM="linux-other" ;;
  esac
elif [ "$(uname -s)" = "Darwin" ]; then
  OS="macos"
  FAMILY="mac"
  PLATFORM="macos"
elif command -v powershell.exe >/dev/null 2>&1 || [ "${OS:-}" = "Windows_NT" ]; then
  OS="windows"
  FAMILY="windows"
  PLATFORM="windows"
fi
printf 'OS=%s\nFAMILY=%s\nPLATFORM=%s\n' "$OS" "$FAMILY" "$PLATFORM"
