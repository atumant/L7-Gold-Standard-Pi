# Eero app: DHCP reservations, static IPs, and port forwarding

## Short version
For this project, use:
- **DHCP reservations in Eero**
- **DHCP on the host**
- **no host-static IP unless there is a special reason**

If you need port forwarding, point the forward at the reserved IP for the intended interface.

## Why reservations are the right default
On Eero, DHCP reservation is better than setting a static IP directly on the Pi for most home/small-office deployments:
- the router stays authoritative for address management
- the host still gets a predictable address
- fewer chances to misconfigure gateway, mask, or DNS
- less brittle after restoring/replacing hardware

## Correct setup for this deployment
This host currently has two LAN-capable interfaces:
- Ethernet (`eth0`) — should be primary
- Wi-Fi (`wlan0`) — should remain active as backup

Recommended Eero setup:
1. leave the LAN on a private range such as `192.168.0.0/24` unless there is a deliberate reason to change it
2. create a DHCP reservation for the **Ethernet device entry / MAC**
3. create a DHCP reservation for the **Wi-Fi device entry / MAC**
4. if port forwarding is needed, forward only to the **Ethernet reserved IP**
5. do not rely on a random current lease; use the reservation target explicitly
6. rename the two device entries in Eero if possible so they are clearly `Pi wired` and `Pi wifi backup`

For this deployment, Wi-Fi is not disabled. It stays available as a live backup path, but Ethernet remains canonical for management and forwarding.

## Important warning: LAN range
Do **not** put a normal home LAN on a public-looking range such as `196.x.x.x`.

Use RFC1918 private ranges only:
- `192.168.x.x`
- `10.x.x.x`
- `172.16.x.x` through `172.31.x.x`

For this environment, staying on `192.168.0.x` is the least disruptive choice unless there is a subnet conflict.

## In the Eero app, what to change
Use the part of the app that manages:
- device reservations / reserved IPs
- port forwarding / firewall rules

Do **not** casually change:
- the whole LAN subnet
- DHCP mode/range for the entire network
- anything that moves the network off its current private subnet unless planned

## Why reservations may seem to disappear
Common causes:
1. the reservation was created for the wrong MAC address
2. the same host was seen as two devices because Ethernet and Wi-Fi have different MACs
3. the router rebooted before the lease table and reservation mapping settled
4. the reservation exists, but the device renewed on the other interface
5. port forwards were attached to the old/current lease rather than the intended reserved address or intended device identity

## Port forwarding rule for this host
If you must forward a port for this deployment:
- forward to the **Ethernet reserved IP** only
- document the target service and reason
- avoid forwarding to whichever IP the host happened to get that day

## Canonical identity rule
A dual-interface host should be documented as:
- primary management NIC: `eth0`
- backup NIC: `wlan0`
- canonical forwarded IP: Ethernet reservation
- backup IP: Wi-Fi reservation, not used for normal port forwards

## Future deployments: supported scenarios
### Scenario 1: simple and preferred
- one active LAN interface
- one DHCP reservation
- no ambiguity

### Scenario 2: Ethernet primary, Wi-Fi backup-only
- two DHCP reservations
- Ethernet is canonical
- Wi-Fi is emergency/recovery path
- normal docs, tunnels, and forwards point at Ethernet

### Scenario 3: intentional multi-homing
- both interfaces active by design
- route metrics and policy routing documented
- distinct purpose for each interface
- not the default gold-standard profile

### Scenario 4: static IP host
Use only when explicitly required by environment constraints. If used, document:
- IP
- subnet
- gateway
- DNS
- collision-avoidance strategy versus DHCP pool

## Setup wizard implications
A future install/setup wizard should ask for networking explicitly instead of assuming one path.

Required wizard questions:
1. Which interface is the primary management interface?
2. Should any secondary interface be disabled, backup-only, or fully active?
3. What are the MAC addresses for each interface?
4. Are DHCP reservations already created in the router?
5. Which address should be recorded as canonical in docs/savepoints?
6. Are any inbound ports being forwarded? If so, to which reserved IP and why?

Wizard safeguards:
- warn if both Wi-Fi and Ethernet are active on the same subnet
- prefer DHCP reservation over host-static configuration on consumer routers
- present a clear recommendation: single-primary-uplink by default
- if backup Wi-Fi is selected, mark it non-canonical in generated docs
- capture rollback instructions for the selected profile
