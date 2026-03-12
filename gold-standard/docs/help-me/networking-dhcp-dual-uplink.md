# DHCP drift and dual-interface LAN conflict

## Summary
After router and Mac reboots, LAN addresses changed and remote/admin access became confusing or unreliable. The host ended up with both Ethernet and Wi-Fi active on the same LAN, each with its own DHCP lease. That created multiple valid addresses for the same machine and made it unclear which path should be used for management.

Observed live state on the affected host:
- `eth0` = `192.168.0.117`
- `wlan0` = `192.168.0.108`
- both are on `192.168.0.0/16`
- both received DHCP from router `192.168.0.1`
- default route prefers `eth0`, while `wlan0` remains connected as a lower-priority route

## Symptoms
- host IP changed after reboot/router churn
- two local IPs appeared for the same host
- management access became inconsistent because some tools/caches pointed at the old address or the wrong interface
- Mac and/or operator workflows became harder to reason about because both wired and wireless paths were live

## Root cause
The host was allowed to auto-connect on both `eth0` and `wlan0` at the same time on the same LAN segment, with both using DHCP. That is not inherently invalid, but it is a bad default for an admin host unless multi-homing is intentional and explicitly designed.

Consumer routers such as Eero also make deterministic LAN control harder because:
- DHCP reservations are configured through the app rather than full router UI
- local DNS/device naming behavior can lag after reboots
- leases can move if reservations are missing or applied to the wrong MAC

## Gold-standard rule going forward
A management host should have exactly one primary LAN uplink unless there is a documented failover design.

Default policy:
1. choose one primary interface for LAN management
2. reserve its address in DHCP using the router/app
3. disable auto-connect on the secondary LAN interface
4. if a secondary interface is kept for recovery, document it as backup-only and do not rely on it as the canonical management path
5. prefer WireGuard or SSH tunnel paths for stable administration instead of raw changing LAN IPs

## Recommended fix for this incident
Recommended primary interface: `eth0` (wired)

### Step 1: reserve addresses in Eero
Create DHCP reservations in the Eero app for the host MAC addresses.

At minimum reserve the primary interface (`eth0`). If Wi-Fi remains enabled for emergency use, reserve that too so the backup path stays predictable.

Suggested policy:
- primary/canonical admin IP: reserve for `eth0`
- backup only: optional reservation for `wlan0`

## Step 2: prefer Ethernet but keep Wi-Fi as backup
If wired is the primary path and Wi-Fi should remain available as backup, keep both on DHCP but make Ethernet the canonical management path.

Preferred policy:
- `eth0` is the documented/admin address
- `wlan0` is backup-only
- reserve both addresses in Eero
- if both remain connected, Ethernet must stay lower-metric / preferred
- do not rely on Wi-Fi as the canonical address in runbooks

Conservative host-side options:

### Option A: strongest separation
Disable Wi-Fi autoconnect so it is available for manual recovery only.

```bash
sudo nmcli connection modify netplan-wlan0-L7TechInc connection.autoconnect no
sudo nmcli device disconnect wlan0
```

Effect:
- host keeps wired connectivity on `eth0`
- Wi-Fi no longer grabs a second DHCP lease on every boot
- Wi-Fi can still be brought up manually if needed

Manual re-enable if needed:
```bash
sudo nmcli connection modify netplan-wlan0-L7TechInc connection.autoconnect yes
sudo nmcli connection up netplan-wlan0-L7TechInc
```

### Option B: soft backup model
Keep Wi-Fi connected, but treat it as non-canonical and document only Ethernet for normal administration.

Requirements:
- reserve both IPs in Eero
- ensure Ethernet remains the preferred/default route
- never publish the Wi-Fi address as the main management endpoint
- only use Wi-Fi when Ethernet is down or physically unavailable

## Alternative: keep Wi-Fi connected but make it backup-only
If both links must stay present, make the secondary interface non-default and non-canonical. This is more complex and should only be done intentionally.

Example approach:
- keep `eth0` as the only default route
- mark `wlan0` as non-default or higher metric
- do not publish `wlan0` as the management address in docs/runbooks
- still create DHCP reservations for both MACs

This is acceptable for testing, but the simpler and safer default for the gold standard is single-primary-uplink.

## Verification
After applying the preferred fix:
```bash
ip -br addr
ip route
nmcli device status
hostname -I
```

Expected:
- `eth0` remains connected
- `wlan0` is disconnected or non-autoconnecting
- only one canonical LAN address is used in runbooks and operator notes

## Rollback
If disabling Wi-Fi causes problems:
```bash
sudo nmcli connection modify netplan-wlan0-L7TechInc connection.autoconnect yes
sudo nmcli connection up netplan-wlan0-L7TechInc
```

## Prevention for future deployments
Add this to preflight/bootstrap logic:
- detect when both Ethernet and Wi-Fi are active on the same RFC1918 subnet
- stop and warn unless operator explicitly enables multi-homing
- require a declared primary management interface
- print both MAC addresses so DHCP reservations can be created in the router app
- record the canonical management address in deployment output/savepoints

## Operator note
OpenClaw itself is healthy here; the gateway is bound to loopback and was not the source of the network instability. The issue is host/network path ambiguity, not gateway failure.
