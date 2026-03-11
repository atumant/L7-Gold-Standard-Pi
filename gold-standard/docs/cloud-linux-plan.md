# Cloud Linux Plan

## Role
Cloud-hosted variant of the same backend standard.

## Differences from Raspberry Pi
- no Pi Connect
- likely no desktop services to strip
- public networking may be controlled by cloud firewall/security groups
- recovery often uses snapshots instead of SD imaging

## Shared core
- WireGuard
- SSH key auth
- nftables or cloud-native firewall equivalent
- OpenClaw loopback UI + tunneled/admin access
- profile-driven bootstrap
