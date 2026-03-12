# Apply and Rollback

## Current state
Bootstrap now supports rendering configuration output and a conservative apply scaffold.

## Apply flow
1. Set environment variables or source a local profile
2. Run render phase
3. Review rendered output
4. Run apply phase
5. Confirm backup directory exists
6. Verify host state
7. Capture a save point

## Current apply scope
- nftables
- OpenClaw config
- with pre-apply backups of nftables and OpenClaw config state

## Example
```bash
cd gold-standard
source ./bootstrap/profile.example.env
./bootstrap/install.sh render
./bootstrap/install.sh configs
./bootstrap/install.sh openclaw-apply
./bootstrap/apply.sh
./bootstrap/install.sh verify
./bootstrap/install.sh savepoint
```

## Rollback idea
If firewall behavior is wrong, restore the backup copy:
```bash
sudo cp savepoints/apply-backups/<timestamp>/nftables.conf.before /etc/nftables.conf
sudo nft -f /etc/nftables.conf
sudo systemctl restart nftables
```

If OpenClaw config behavior is wrong, restore the backup copy:
```bash
cp savepoints/apply-backups/openclaw.json.<timestamp>.before ~/.openclaw/openclaw.json
openclaw gateway restart
```

## Rule
Keep high-risk auth and remote-access changes explicit and staged. Do not auto-apply SSH lockdown until the rendered/apply model is mature and verified.
