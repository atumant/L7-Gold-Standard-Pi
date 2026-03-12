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
sudo ss -ltnup | egrep '(:22\s|:18789\s|:51820\s|:111\s|:631\s|Local Address)' || true

echo '=== OpenClaw ==='
openclaw status | sed -n '1,30p' || true

echo '=== Service state ==='
sudo systemctl is-active ssh nftables 2>/dev/null || true
systemctl --user is-active openclaw-gateway 2>/dev/null || true
sudo systemctl is-active rpcbind avahi-daemon ModemManager cups cups-browsed 2>/dev/null || true
