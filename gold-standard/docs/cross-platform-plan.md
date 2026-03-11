# Cross-platform plan

## Supported tracks
### 1. Raspberry Pi / Debian-like Linux
Primary first-class path.
- apt-based package automation
- systemd service management
- nftables
- WireGuard server/client
- OpenClaw gateway host

### 2. Cloud Linux
Mostly the same as Debian-like path, but with profile differences:
- public cloud networking/security groups
- no Pi Connect assumptions
- often no desktop services to strip

### 3. macOS
Primarily operator/development/control host path.
- VS Code + GitHub auth
- local SSH/WireGuard client usage
- optional local OpenClaw profile

### 4. Windows
Primarily operator/client path initially.
- PowerShell/winget bootstrap later
- WireGuard client
- SSH client
- future OpenClaw-friendly workflow docs

## Rule
Do not pretend all platforms have identical security primitives. Build platform-specific phases under one consistent profile/reporting model.
