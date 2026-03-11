# Savepoint — 2026-03-10 Pi GitHub auth enabled

## Git state
- Pi repo remote switched to SSH
- Dedicated Pi GitHub SSH key created and added to GitHub
- Pi can authenticate to GitHub directly
- Pending Pi commits ready to push upstream

## Why this matters
This removes the need for repeated bundle/export transfer cycles from Pi to Mac for every iteration.

## New workflow
- Pi-side agent work can commit and push directly
- Mac VS Code can pull/sync from GitHub
- GitHub remains the upstream source of truth
