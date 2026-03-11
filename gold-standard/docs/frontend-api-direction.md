# Front-end / API Direction

## Goal
Allow a future front-end installer UI (for example built in Lovable) to drive the bootstrap process for:
- Raspberry Pi
- cloud instances
- Mac
- Windows

## Recommended architecture
Do not let the front-end mutate hosts directly.
Use a thin API/control layer that:
1. collects profile inputs
2. generates a host profile/env payload
3. invokes staged bootstrap phases
4. stores logs/save points
5. returns progress and verification results

## Good front-end targets
- GitHub repo templates / profile files
- a future bootstrap API service
- generated config bundles
- downloadable one-line launcher commands

## Suggested API shape (future)
- `POST /profiles` → create/update a host profile
- `POST /bootstrap/render` → render outputs for a profile
- `POST /bootstrap/apply` → apply a safe phase
- `GET /bootstrap/status/:id` → logs/results
- `GET /savepoints` → list checkpoints

## Why this matters for Lovable
Lovable can work well as a front-end/UI layer, but the system logic should remain in versioned scripts and profile definitions, not hidden in prompt-only UI flows.

## Immediate takeaway
Keep building the bootstrap as scriptable primitives first. Then expose those primitives through a front-end/API layer.
