# Backup and Image Plan

## Goal
Make the hardened host cheap and repeatable to recover or clone.

## Layers
### 1. Git-backed configuration
- docs
- scripts
- templates
- profiles

### 2. Save points
- rendered configs
- verification outputs
- host facts
- dated checkpoints

### 3. Host backups
- filesystem/config backups
- optional encrypted archives

### 4. Full image strategy
- SD card / disk imaging for Raspberry Pi
- cloud snapshot equivalents for cloud Linux

## Practical recommendation
For Raspberry Pi:
- keep config and bootstrap in git
- capture save points regularly
- add a script later to create an image or rsync-style backup target
- plan a rebuildable encrypted install instead of trusting ad-hoc drift forever
