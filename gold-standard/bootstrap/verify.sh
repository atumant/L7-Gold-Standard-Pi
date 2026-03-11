#!/usr/bin/env bash
set -euo pipefail
echo '=== WireGuard ==='
ip -brief address show wg0 || true
sudo wg show wg0 || true
echo '=== Firewall ==='
sudo nft list ruleset
echo '=== SSH posture ==='
sudo sshd -T | egrep '^(passwordauthentication|pubkeyauthentication|x11forwarding|allowtcpforwarding|allowagentforwarding|allowstreamlocalforwarding)'
echo '=== Listeners ==='
sudo ss -ltnup | egrep '(:22\s|:51820\s|:111\s|:631\s|Local Address)' || true
