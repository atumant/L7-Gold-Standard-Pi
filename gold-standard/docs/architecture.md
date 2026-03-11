# Architecture

## Target role
Dedicated Raspberry Pi admin host for OpenClaw and future private services.

## Remote access pattern
- Public exposure: WireGuard UDP port only
- Primary admin path: WireGuard
- Admin shell: SSH over WireGuard using ed25519 keys
- Break-glass path: local console + LAN SSH
- OpenClaw UI: SSH local port forward to loopback-bound Control UI
- Pi Connect: preserved as a secondary remote path during migration/hardening

## Network security
- nftables default deny inbound
- allow loopback
- allow established/related
- allow ICMP
- allow LAN subnet
- allow WireGuard subnet
- allow WireGuard UDP from internet

## SSH posture
- PasswordAuthentication no
- PubkeyAuthentication yes
- X11Forwarding no
- AllowAgentForwarding no
- AllowTcpForwarding yes (required for OpenClaw UI tunnel)
- AllowStreamLocalForwarding yes (review later)

## OpenClaw posture
- Gateway bound to loopback
- Remote access through SSH tunnel or later authenticated reverse-proxy design
- Gateway token required for Control UI browser session

## Deferred hardening
- full-disk encryption via rebuild/migration
- backup and recovery automation
- MFA layer for browser/admin path
- additional service minimization
- optional reduction of remaining SSH forwarding capabilities
