# Workflow: Mac ↔ GitHub ↔ Pi

## Recommended source-of-truth model
- Primary development environment: Mac + VS Code
- Canonical remote: GitHub
- Deployment/runtime node: Raspberry Pi
- Optional local clone on Pi for execution, verification, and recovery

## Why this model
- VS Code on the Mac is the cleanest place for GUI-based GitHub authentication
- GitHub becomes the durable upstream and collaboration point
- The Pi stays focused on runtime, validation, and deployment
- Changes made by the agent inside the workspace repo can use a dedicated git author identity

## Current local repo identity for agent-made commits
This workspace repo is configured with:
- user.name = Azrael_Atum
- user.email = azrael_atum@local

That means local commits made here by the agent will show as Azrael_Atum in git history for this repository.

## Important limitation
The agent is currently operating on the Pi host, not inside your Mac desktop session. That means:
- it can prepare the repository and commands
- it can document the secure workflow
- it can set git identity locally on the Pi
- but it cannot honestly complete your Mac VS Code GUI OAuth flow unless you perform that sign-in on the Mac

## Best auth path for GitHub
Preferred order:
1. GitHub auth on the Mac via VS Code or GitHub CLI
2. Use SSH auth or GitHub CLI for repo operations on the Mac
3. Push from the Mac to GitHub
4. Pull/clone from the Pi as needed

## Recommended repo topology
- Mac projects folder:
  - working clone for active development
- GitHub:
  - upstream remote
- Pi:
  - deploy/test clone or mirrored working copy when needed

## Secure auth guidance
- Prefer GitHub SSH keys or GitHub CLI login on the Mac
- Avoid storing broad long-lived GitHub PATs in repo files
- Do not commit secrets, tokens, or local-only operator files

## Current project copies
The following home-folder operational checkpoint files were copied into the project tree for documentation continuity:
- gold-standard/savepoints/live-home-copies/zero-trust-wireguard-checkpoint.txt
- gold-standard/savepoints/live-home-copies/zero-trust-wireguard-resume-commands.txt

## Proposed next implementation steps
1. Add .gitignore and bootstrap scaffolding
2. Create publish instructions for Mac-based GitHub setup
3. On the Mac, authenticate to GitHub in VS Code or GitHub CLI
4. Create a GitHub repository
5. Push this project from the Mac
6. Optionally clone/pull on the Pi for deployment use
