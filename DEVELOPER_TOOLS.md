# Developer Tools Reference

Quick reference for all developer tools and utilities in the FlashFusion SoT monorepo.

## Quick Start

```bash
# One-command setup for new developers
make bootstrap
```

---

## Makefile Commands

Run `make help` to see all available commands.

### Setup & Installation

| Command | Description |
|---------|-------------|
| `make bootstrap` | Complete setup (installs deps, builds, validates) |
| `make install` | Install all dependencies |
| `make reinstall` | Clean install (removes node_modules first) |

### Build & Development

| Command | Description |
|---------|-------------|
| `make build` | Build all projects |
| `make build-changed` | Build only changed projects |
| `make dev` | Start all development servers |
| `make dev-web` | Start web app only |
| `make dev-api` | Start API server only |

### Testing & Quality

| Command | Description |
|---------|-------------|
| `make test` | Run all tests |
| `make test-watch` | Run tests in watch mode |
| `make test-coverage` | Run tests with coverage |
| `make lint` | Lint all code |
| `make lint-fix` | Lint and auto-fix issues |
| `make format` | Format code with Prettier |
| `make type-check` | TypeScript type checking |
| `make check` | Run all checks (lint + type-check) |

### Cleaning

| Command | Description |
|---------|-------------|
| `make clean` | Clean build artifacts |
| `make clean-all` | Deep clean (includes node_modules) |

### Repository Management

| Command | Description |
|---------|-------------|
| `make import` | Import remaining GitHub repositories |
| `make validate` | Validate setup and configuration |
| `make repo-map` | Regenerate repository map |

### Security

| Command | Description |
|---------|-------------|
| `make security` | Run security audit |
| `make security-check` | Audit (fails on moderate+ vulnerabilities) |
| `make update-deps` | Update dependencies (interactive) |
| `make outdated` | Show outdated dependencies |

### Development Services

| Command | Description |
|---------|-------------|
| `make services` | Start PostgreSQL & Redis |
| `make services-stop` | Stop services |
| `make services-logs` | View service logs |
| `make services-clean` | Stop and remove all data |

### Documentation

| Command | Description |
|---------|-------------|
| `make docs-status` | Check documentation status |
| `make docs-lint` | Lint markdown files |

### Diagnostics

| Command | Description |
|---------|-------------|
| `make health` | Run health checks |
| `make doctor` | Full diagnostic (validate + health) |
| `make info` | Show environment information |

### Git Helpers

| Command | Description |
|---------|-------------|
| `make status` | Comprehensive git status |
| `make sync` | Sync with upstream |

### CI/CD Simulation

| Command | Description |
|---------|-------------|
| `make ci-local` | Simulate CI pipeline locally |

### Aliases

| Alias | Full Command |
|-------|--------------|
| `make b` | `make build` |
| `make d` | `make dev` |
| `make t` | `make test` |
| `make l` | `make lint` |
| `make c` | `make clean` |
| `make i` | `make install` |

---

## Scripts

All scripts are in the `scripts/` directory.

### Bootstrap Script

**File**: `scripts/bootstrap.sh`

Complete automated setup:

```bash
./scripts/bootstrap.sh

# Skip build step (faster)
./scripts/bootstrap.sh --skip-build
```

Features:
- ✅ Checks Node.js version
- ✅ Installs/checks pnpm
- ✅ Creates .env from template
- ✅ Installs dependencies
- ✅ Sets up git hooks
- ✅ Builds all projects
- ✅ Validates setup

### Validation Script

**File**: `scripts/validate-setup.sh`

Validates deployment setup:

```bash
./scripts/validate-setup.sh
```

Checks:
- Prerequisites (gh CLI, ssh-keygen)
- File structure
- Deploy keys
- GitHub Actions secrets
- Repository access

### Health Check Script

**File**: `scripts/health-check.sh`

Verifies system health:

```bash
./scripts/health-check.sh
```

Checks:
- Type checking
- Linting
- Tests
- Security audit

### Import Script

**File**: `scripts/import-github-repos.sh`

Import GitHub repositories:

```bash
./scripts/import-github-repos.sh
```

Imports all 50 pending repositories from GitHub.

### Repository Map Generator

**File**: `scripts/generate-repo-map.js`

Generate/update REPO_MAP.md:

```bash
node scripts/generate-repo-map.js
# OR
make repo-map
```

---

## VS Code Dev Container

### Setup

1. Install prerequisites:
   - [Docker Desktop](https://www.docker.com/products/docker-desktop)
   - [VS Code](https://code.visualstudio.com/)
   - [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

2. Open in container:
   - Open repo in VS Code
   - Press `F1`
   - Select "Dev Containers: Reopen in Container"
   - Wait for setup (5-10 minutes first time)

### What's Included

**Services**:
- PostgreSQL 16
- Redis 7
- Node.js 20

**Tools**:
- pnpm 9.0.0
- GitHub CLI
- Docker-in-Docker
- PostgreSQL client
- Redis tools

**VS Code Extensions**:
- ESLint & Prettier
- TypeScript
- TailwindCSS
- GitLens
- Docker
- SQL Tools
- GitHub Copilot

### Configuration

All configuration in `.devcontainer/`:
- `devcontainer.json` - Main config
- `docker-compose.yml` - Services
- `Dockerfile` - Container image
- `post-create.sh` - Setup script
- `README.md` - Full documentation

---

## Docker Services

### Start Services

```bash
make services
# OR
docker-compose up -d
```

Starts:
- PostgreSQL on port 5432
- Redis on port 6379

### Configuration

Edit `.env` file:

```bash
cp .env.example .env
nano .env
```

Variables:
- `POSTGRES_DB` - Database name (default: flashfusion_dev)
- `POSTGRES_USER` - Username (default: dev)
- `POSTGRES_PASSWORD` - Password (default: dev)
- `POSTGRES_PORT` - Port (default: 5432)
- `REDIS_PORT` - Port (default: 6379)
- `REDIS_PASSWORD` - Password (optional)

### Connect to Services

**PostgreSQL**:
```bash
psql -h localhost -U dev -d flashfusion_dev
```

**Redis**:
```bash
redis-cli
```

### Stop Services

```bash
make services-stop
# OR
docker-compose down
```

### Clean All Data

```bash
make services-clean
# OR
docker-compose down -v
```

---

## Environment Configuration

### Create .env File

```bash
cp .env.example .env
```

### Key Variables

**GitHub**:
- `GITHUB_TOKEN` - For importing repos (requires repo scope)

**Database**:
- `POSTGRES_*` - PostgreSQL connection
- `REDIS_*` - Redis connection

**Turbo**:
- `TURBO_TOKEN` - Remote caching (optional)
- `TURBO_TEAM` - Team slug (optional)

**Monitoring**:
- `SENTRY_DSN` - Error tracking (optional)
- `OTEL_*` - OpenTelemetry (optional)

### Project-Specific .env

Individual projects have their own `.env.example` files:
- `projects/local/flashfusion-consolidated/packages/ai-core/.env.example`
- `projects/local/flashfusion-consolidated/packages/shared/.env.example`
- `projects/local/int-smart-triage-ai-2.0/.env.example`

---

## Git Hooks

### Pre-commit

**File**: `.husky/pre-commit`

Runs on every commit:
- Lints staged files
- Formats code with Prettier

### Commit-msg

**File**: `.husky/commit-msg`

Validates commit messages:
- Enforces Conventional Commits format
- Examples: `feat:`, `fix:`, `docs:`, etc.

### Pre-push

**File**: `.husky/pre-push`

Runs before pushing:
- Lints all code
- Type checks
- Runs tests

**Disable temporarily**:
```bash
git push --no-verify
```

---

## Node Version Management

### .nvmrc

Specifies Node.js 20:

```bash
# Use with nvm
nvm use

# Use with fnm
fnm use
```

### .tool-versions

For asdf users:

```bash
asdf install
```

---

## Troubleshooting

### Bootstrap Fails

```bash
# Clean and retry
make clean-all
make bootstrap
```

### Services Won't Start

```bash
# Check Docker is running
docker ps

# Check logs
make services-logs

# Restart services
make services-stop
make services
```

### Pre-push Hook Fails

```bash
# Fix issues
make lint-fix
make test

# Or skip hook (not recommended)
git push --no-verify
```

### Dev Container Won't Build

1. Ensure Docker has 4GB+ RAM
2. Rebuild container: `F1` → "Dev Containers: Rebuild Container"
3. Check `.devcontainer/README.md` for more troubleshooting

---

## Learn More

- **Getting Started**: `GETTING_STARTED.md`
- **Contributing**: `CONTRIBUTING.md`
- **AI Guide**: `CLAUDE.md`
- **Full Docs**: `docs/`
- **Makefile Source**: `Makefile`
- **Scripts Documentation**: `scripts/README.md`
- **Dev Container Docs**: `.devcontainer/README.md`
