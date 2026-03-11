# GitHub Publish Runbook

## Goal
Publish the `gold-standard` project to GitHub while preserving a clean development model:
- Mac = authoring and GUI authentication
- GitHub = upstream
- Pi = deployment/runtime/test host

## Why publish from the Mac
The Mac is the right place to:
- authenticate to GitHub via VS Code GUI
- manage project folders
- use your normal identity and desktop workflow
- avoid storing unnecessary GitHub auth on the Pi

## Recommended Mac-side flow
### Option A: VS Code GitHub sign-in
1. Open the project folder in VS Code on the Mac
2. Use the Accounts/GitHub sign-in flow in VS Code
3. Authorize GitHub access in the browser
4. Use VS Code source control to initialize/publish or connect the repo

### Option B: GitHub CLI
```bash
gh auth login
```
Then create/publish a repo.

## Recommended git identity split
- Human-authored Mac commits: your normal Git identity
- Agent-authored Pi/workspace commits: Azrael_Atum

If you want *all* project commits from this automation line to appear as Azrael_Atum, configure that identity in the relevant working clone before commit.

## Suggested remote setup
```bash
git remote add origin git@github.com:<owner>/<repo>.git
# or HTTPS remote if you prefer GitHub credential manager / VS Code GUI auth
```

## Push example
```bash
git push -u origin main
```

## Pi usage after publish
On the Pi, either:
- keep using the workspace repo as the local operational copy, or
- clone a separate deployment copy from GitHub

## Security note
Do not commit:
- WireGuard private keys
- gateway tokens
- device pairing state
- local secrets
- raw home-folder secrets
