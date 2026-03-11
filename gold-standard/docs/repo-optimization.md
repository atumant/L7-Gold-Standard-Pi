# Repo Optimization Policy

## Goal
Keep the repository lean, durable, and scalable.

## Track in git
- source scripts
- templates
- docs
- selected manual save points
- example profiles

## Do not track routinely
- generated run output directories
- repetitive rendered host facts
- transient logs
- large archives
- secrets

## Runtime storage pattern
- write detailed run artifacts to `output/<run-id>/`
- compress them to `archives/<run-id>.tar.gz` when needed
- do not track routine outputs or archives in git
- keep only durable/manual save points in git

## Why
This reduces:
- token waste when reading repo state
- git noise
- storage growth
- frontend complexity

## Principle
Durable knowledge belongs in docs/templates/save points.
Ephemeral execution detail belongs in ignored runtime output, optionally archived.
