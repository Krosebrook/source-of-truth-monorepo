# Codex Workspace

Curated local documentation and tooling for managing secrets across GitHub Actions, Vercel, and Docker-based development workflows.

## Repository Layout

- `docs/secrets/` — Guidance for bridging secrets between CI/CD, production, and local environments.
- `docs/ai/` — Claude/agent playbooks, session notes, and operational checklists.
- `scripts/` — Utility scripts to safely update `.env` files and optionally sync values to Vercel.
- `templates/` — Starter configuration files such as `env.example`.

## Claude & Agent Playbooks

- [Kyler + Claude Collaboration Playbook (Q4 2025)](docs/ai/claude.md) — Model selection, prompting patterns, and Codex CLI rituals.
- [Kyler Agent Platform Guide (Q4 2025)](docs/ai/agents.md) — Architecture, safety guardrails, and evaluation pipeline.
- [Session Notes – 2025-10-27](docs/ai/session-2025-10-27-claude-agent-refresh.md) — Research summary and follow-up actions for the current update.

## Getting Started

1. Copy `templates/env.example` to `.env` at the repository root and fill in real values.
2. Review `docs/secrets/secrets-bridge-pattern.md` to confirm how secrets flow across environments.
3. When you have Stripe credentials, set the environment variables (or edit the script) and run:

```bash
cd codex-workspace
bash scripts/update_stripe_env.sh
```

The script creates a timestamped backup before patching your `.env`. Set `SYNC_VERCEL=1` if you want the script to push updates to Vercel using the logged-in CLI.

## Operational Tips

- Keep `.env` out of version control (`.gitignore` includes it by default).
- Store production secrets in GitHub/Vercel, not on laptops.
- Use GitHub Actions to deliver secrets to Docker images through build arguments or mounted files.
