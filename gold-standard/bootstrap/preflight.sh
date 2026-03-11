#!/usr/bin/env bash
set -euo pipefail

echo '== Preflight =='
uname -a
[ -f /etc/os-release ] && cat /etc/os-release

echo '== User =='
id

echo '== Required commands =='
for cmd in git wg systemctl ip ss; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "OK   $cmd -> $(command -v "$cmd")"
  else
    echo "MISS $cmd"
  fi
done

for path in /usr/sbin/nft /usr/sbin/sshd; do
  if [ -x "$path" ]; then
    echo "OK   $path"
  else
    echo "MISS $path"
  fi
done

echo '== Network summary =='
ip -brief address

echo '== WireGuard summary =='
ip -brief address show wg0 || true
sudo wg show wg0 || true

echo '== Firewall summary =='
sudo nft list ruleset || true

echo '== SSH summary =='
sudo sshd -T | egrep '^(passwordauthentication|pubkeyauthentication|x11forwarding|allowtcpforwarding|allowagentforwarding|allowstreamlocalforwarding)' || true
