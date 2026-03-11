# Pi GitHub Auth Runbook

## Goal
Allow the Pi workspace repo to push directly to GitHub using a dedicated SSH key, so Pi-side agent commits can be pushed upstream without bundle/export loops.

## Design
- Dedicated SSH key on the Pi for GitHub
- Git remote uses SSH URL
- Key is scoped to GitHub use
- Public key is added to the GitHub account manually by the operator

## Generated key identity
- Comment: `Azrael_Atum-TechPi-GitHub`
- Private key path: `/home/admin/.ssh/github_azrael_atum`
- Public key path: `/home/admin/.ssh/github_azrael_atum.pub`

## SSH config recommendation
Add a GitHub host stanza using this dedicated key.

## Remote URL format
```text
git@github.com:atumant/L7-Gold-Standard-Pi.git
```

## Operator action
Copy the public key directly from the host-local file when adding it to GitHub:
```bash
cat /home/admin/.ssh/github_azrael_atum.pub
```

## Security note
Do not commit the private key. For privacy hygiene, do not keep the public key in the tracked repository either; copy it from the local `.pub` file when needed.
