#!/usr/bin/env bash
set -euo pipefail
EVAL="${1:-plan}"
eval "$($(dirname "$0")/platform-detect.sh)"

echo "== Package automation =="
echo "Platform: $PLATFORM"
case "$PLATFORM" in
  debian-like)
    PKGS=(wireguard wireguard-tools nftables qrencode git curl)
    echo "Packages: ${PKGS[*]}"
    if [ "$EVAL" = "apply" ]; then
      sudo apt-get update
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${PKGS[@]}"
    else
      echo "Plan only. Re-run with: packages-auto.sh apply"
    fi
    ;;
  macos)
    echo "Planned packages/tools: git curl wireguard-tools (if needed)"
    echo "Recommend Homebrew-managed bootstrap path for macOS"
    ;;
  windows)
    echo "Planned tools: git, WireGuard client, OpenSSH, PowerShell bootstrap"
    echo "Recommend winget/choco-based path later"
    ;;
  *)
    echo "Unsupported/unknown platform for package auto-install"
    exit 1
    ;;
esac
