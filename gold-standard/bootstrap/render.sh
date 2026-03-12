#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/rendered"
mkdir -p "$OUT"

WG_SUBNET="${WG_SUBNET:-10.77.0.0/24}"
WG_LISTEN_PORT="${WG_LISTEN_PORT:-51820}"
LAN_IFACES="${LAN_IFACES:-eth0,wlan0}"
TAILSCALE_IFACE="${TAILSCALE_IFACE:-tailscale0}"
OPENCLAW_GATEWAY_PORT="${OPENCLAW_GATEWAY_PORT:-18789}"

LAN_IFACES_NFT="$(printf '%s' "$LAN_IFACES" | sed 's/,/", "/g')"

cat > "$OUT/nftables.conf" <<EOF
#!/usr/sbin/nft -f
flush ruleset

table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;

    iif "lo" accept
    ct state established,related accept
    ct state invalid drop

    ip protocol icmp accept
    ip6 nexthdr ipv6-icmp accept

    iifname { "${LAN_IFACES_NFT}" } tcp dport 22 accept
    iifname { "${LAN_IFACES_NFT}" } tcp dport ${OPENCLAW_GATEWAY_PORT} accept
    ip saddr ${WG_SUBNET} tcp dport 22 accept
    iifname "${TAILSCALE_IFACE}" tcp dport 22 accept

    udp dport ${WG_LISTEN_PORT} accept
  }

  chain forward {
    type filter hook forward priority 0; policy drop;
  }

  chain output {
    type filter hook output priority 0; policy accept;
  }
}
EOF

"$ROOT/bootstrap/render-ssh.sh"

echo "Rendered to: $OUT"
ls -l "$OUT"
