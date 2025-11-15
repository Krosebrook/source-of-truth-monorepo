# Secrets Bridge Pattern

## Overview

Modern projects touch multiple execution environments, each with different security guarantees. This guide explains how to keep secrets scoped correctly while still letting CI/CD tooling hand off the values your applications need.

## Primary Stores

- **GitHub Secrets**: Encrypt CI/CD-only credentials (API keys, deploy tokens, signing certs). Use them exclusively inside GitHub Actions workflows.
- **Vercel Environment Variables**: Hold production-only runtime configuration. Manage them through the Vercel dashboard to keep secrets out of client bundles.
- **Local `.env` files + Docker Compose**: Store developer-only values for running services on a workstation. Add `.env` to `.gitignore` so raw secrets never enter version control.

## Bridge Flow

1. **GitHub Actions workflow** pulls from GitHub Secrets.
2. Inject values into the build step with `env`, `with.args`, or mounted files.
3. Pass secrets into `docker build` via build arguments or into `docker compose` with temporary `.env` files/volumes.
4. Containers read secrets via environment variables at runtime; nothing sensitive persists in the image.

## Guardrails

- Rotate secrets regularly and revoke any leaked credentials immediately.
- Split keys by environment (`development`, `preview`, `production`) to avoid cross-contamination.
- Never rely on GitHub Secrets for local development; hydrate `.env` files through scripts or tooling instead.
- Document every secret: purpose, owner, rotation policy, and the workflow that consumes it.
