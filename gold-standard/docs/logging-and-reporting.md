# Logging and Reporting Model

## Goal
Every bootstrap/apply run should leave a readable trace.

## Current building blocks
- `bootstrap/log-init.sh`
- rendered outputs in `rendered/`
- save points in `savepoints/`
- git commit history

## Desired next stage
Each run should capture:
- timestamp
- phase
- profile used
- rendered files
- verification results
- failures
- backup paths

## Front-end/API implication
A future API wrapper should surface these run artifacts to a UI without reimplementing the actual host logic.
