# MFA Layer Design

## Goal
Add MFA to the administrative access path without breaking the currently working core path.

## Current access path
- WireGuard tunnel
- SSH key auth
- OpenClaw UI via SSH tunnel
- Pi Connect preserved separately

## Recommended MFA design progression
### Phase 1
- keep WireGuard + SSH key path as the base trusted path
- use GitHub / provider MFA for code-hosting/admin ecosystem
- maintain strong key hygiene

### Phase 2
- add an identity-aware access layer for web/admin surfaces
- require TOTP or hardware-backed auth where possible

### Phase 3
- consider VPN identity layer with stronger user/device policy
- consider SSO/IdP-backed MFA if operating this as a business platform

## Important truth
SSH key auth is strong, but it is not the same thing as a full MFA web/admin access program. Build MFA on top of the proven transport/admin path instead of destabilizing it prematurely.
