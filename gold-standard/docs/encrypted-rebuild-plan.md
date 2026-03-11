# Encrypted Rebuild Plan

## Reality
The current Pi root filesystem was not deployed with full-disk encryption. That is not something to hand-wave into existence safely with a tiny in-place toggle.

## Clean path
1. Keep the current host stable and documented
2. Build a reproducible bootstrap/install path in git
3. Define an encrypted target install strategy
4. Rebuild onto encrypted media or a new device
5. Reapply configuration using the bootstrap system
6. Verify access, firewall, WireGuard, and OpenClaw

## Why this is better
- auditable
- repeatable
- lower risk than ad-hoc in-place surgery
- better for a future business-grade standard
