# Debian / Pi OpenClaw Automation

## Goal
Make Debian/Pi the first-class fully automated install path.

## Current sequence
1. platform detect
2. package auto-install
3. OpenClaw install/verify
4. profile render
5. staged firewall apply
6. staged SSH apply
7. staged service minimization
8. gateway verification
9. save point

## OpenClaw LAN access policy
For trusted local-network use, OpenClaw can bind on a LAN-reachable address while still using gateway auth.

Current rendered defaults:
- `OPENCLAW_GATEWAY_BIND=lan`
- `OPENCLAW_GATEWAY_PORT=18789`
- nftables allows `18789/tcp` only on declared LAN interfaces
- SSH remains allowed on LAN interfaces plus WireGuard/Tailscale

This keeps remote administration available over VPN while avoiding a VPN requirement when the operator is already on the local network.

## Why Debian/Pi first
That is the current live-reference environment and the fastest path to a reproducible business-grade baseline.
