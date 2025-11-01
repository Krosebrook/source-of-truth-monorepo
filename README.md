# FlashFusion Source-of-Truth Monorepo

Unified consolidation of 53 repositories across the FlashFusion ecosystem.

## Overview

This monorepo serves as the **Source-of-Truth (SoT)** for all FlashFusion projects, tools, and agents. It uses a **SoT canonical** ownership model where all changes are made here and pushed to downstream mirrors.

### Repository Count

- **Local repos**: 3 (flashfusion-consolidated, HarvestFlow, INT-Smart-Triage-AI-2.0)
- **Krosebrook**: 34 repos
- **flashfusionv1**: 8 repos
- **ChaosClubCo**: 8 repos
- **Total**: 53 repositories

## Structure

```
source-of-truth-monorepo/
├── projects/                    # All project code
│   ├── local/                   # Local-only repos
│   ├── krosebrook/              # Krosebrook org repos
│   │   ├── core/                # Core FlashFusion projects
│   │   ├── apps/                # Applications
│   │   └── tools/               # Development tools
│   ├── flashfusionv1/           # FlashFusionv1 org repos
│   └── chaosclubco/             # ChaosClubCo org repos
├── agents/                      # AI agent implementations
│   ├── claude-agent/
│   ├── codex-agent/
│   ├── gemini-agent/
│   └── github-agent/
├── shared/                      # Shared utilities
│   ├── contracts/               # Agent output schemas
│   ├── logging/                 # Structured logging
│   ├── otel/                    # Observability (OTEL)
│   └── workflows/               # CI/CD utilities
└── .github/                     # GitHub workflows

```

## Tech Stack

- **Package Manager**: pnpm 9.x
- **Build Tool**: Turbo
- **Versioning**: Changesets (independent package versions)
- **CI/CD**: GitHub Actions
- **Security**: gitleaks, Renovate, pnpm audit
- **Observability**: Structured JSON logs, OTEL-ready

## Quick Start

### Prerequisites

- Node.js 20+
- pnpm 9+

### Installation

```bash
# Clone the repository
git clone git@github.com:Krosebrook/source-of-truth-monorepo.git
cd source-of-truth-monorepo

# Install dependencies
pnpm install

# Build all projects
pnpm build

# Run linting
pnpm lint

# Run tests
pnpm test
```

### Development

```bash
# Start dev mode for all projects
pnpm dev

# Build only changed projects
pnpm build --filter=...[HEAD^]

# Lint specific project
pnpm --filter @flashfusion/project-name lint
```

## Ownership Model

**SoT Canonical** (default for all projects):

- All development happens in this monorepo
- Changes are pushed to downstream mirrors via `git subtree split`
- **Never commit directly to mirror repos**

## CI/CD

### Workflows

- **CI** (`ci.yml`): Runs lint, build, test on every push/PR
- **Security** (`security.yml`): gitleaks scan + dependency audit
- **Subtree Push** (`subtree-push.yml`): Pushes changes to 50 mirrors (requires deploy keys)
  - **Status**: ✅ Infrastructure Complete - Ready for Activation
  - **Activation Guide**: [Quick Start](docs/how-to/ACTIVATION_GUIDE.md)
  - **Setup Guide**: [Configure Deploy Keys](docs/how-to/configure-deploy-keys.md)
  - **Validation**: Run `./scripts/validate-setup.sh`

### Turbo Caching

Turbo caches build outputs to speed up CI. Only changed projects + dependencies are rebuilt.

## Agent Parity

All agents (Claude, Codex, Gemini, GitHub Agent) follow unified contracts:

### CLI Flags

```bash
agent-cli --prompt <path> --context <path> --output-schema <path> --out <dir>
```

### Output Schema

All agents output JSON conforming to `shared/contracts/agent-output.schema.json`.

See: [shared/contracts/README.md](shared/contracts/README.md)

## Documentation

- [REPO_MAP.md](REPO_MAP.md) - Complete index of all 53 repositories
- [shared/contracts/README.md](shared/contracts/README.md) - Agent contracts
- [shared/logging/README.md](shared/logging/README.md) - Logging guide
- [Deploy Keys Setup](docs/how-to/configure-deploy-keys.md) - Mirror sync configuration

## Security

### Secrets Management

- All secrets stored in GitHub Secrets
- Deploy keys provisioned per-mirror (write-only, unique per repo)
- 50 mirror repositories configured (pending key setup)
- No `.env` files committed (see `.gitignore`)
- **Setup Guide**: [Configure Deploy Keys](docs/how-to/configure-deploy-keys.md)

### Audits

```bash
# Run security audit
pnpm -r audit

# Scan for secrets
gh workflow run security.yml
```

## Versioning & Releases

This monorepo uses **Changesets** for independent package versioning:

```bash
# Create a changeset
pnpm changeset

# Version packages
pnpm changeset version

# Publish (when ready)
pnpm release
```

## Contributing

1. Create a feature branch
2. Make changes in this SoT repo (not mirrors!)
3. Run `pnpm lint && pnpm build && pnpm test`
4. Create a PR
5. After merge, CI automatically pushes to mirrors

See: [CODEOWNERS](.github/CODEOWNERS)

## Troubleshooting

### Build Failures

```bash
# Clean all build artifacts
pnpm clean

# Reinstall dependencies
rm -rf node_modules
pnpm install
```

### Import Errors

If projects reference each other, ensure proper workspace dependencies:

```json
{
  "dependencies": {
    "@flashfusion/other-project": "workspace:*"
  }
}
```

## License

MIT (see individual project licenses)

## Support

- Issues: https://github.com/Krosebrook/source-of-truth-monorepo/issues
- Docs: https://flashfusion.co
