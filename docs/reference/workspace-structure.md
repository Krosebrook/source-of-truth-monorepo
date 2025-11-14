# Workspace Structure Reference

> Complete technical specification of the SoT monorepo layout

**Type**: Reference
**Audience**: Developers, architects
**Last Updated**: 2025-10-27

---

## Overview

The FlashFusion Source-of-Truth monorepo follows a **multi-tier organization**:

```
source-of-truth-monorepo/
├── projects/       # All project code (53 repos)
├── agents/         # AI agent implementations
├── shared/         # Shared utilities & contracts
├── scripts/        # Automation scripts
├── docs/           # Diátaxis documentation
└── .github/        # CI/CD workflows
```

---

## Top-Level Directories

### `/projects/` - Project Repositories

Contains all 53 imported repositories, organized by origin:

```
projects/
├── local/          # Local-only repositories (no GitHub remote)
├── krosebrook/     # Krosebrook organization repos
├── flashfusionv1/  # FlashFusionv1 organization repos
└── chaosclubco/    # ChaosClubCo organization repos
```

**Total Count**: 53 repositories

### `/agents/` - AI Agent Implementations

```
agents/
├── claude-agent/       # Anthropic Claude integration
├── codex-agent/        # OpenAI Codex integration
├── gemini-agent/       # Google Gemini integration
└── github-agent/       # GitHub Copilot integration
```

**Purpose**: Unified AI agent templates with standard CLI

### `/shared/` - Shared Utilities

```
shared/
├── contracts/          # JSON schemas & agent contracts
│   ├── agent-output.schema.json
│   └── README.md
├── logging/            # Structured JSON logging
│   ├── json-logger.ts
│   └── package.json
├── otel/              # OpenTelemetry configuration (future)
└── workflows/         # CI/CD utilities (future)
```

**Purpose**: Code shared across all 53 projects

### `/scripts/` - Automation Scripts

```
scripts/
└── import-github-repos.sh    # Batch import 50 GitHub repos
```

**Purpose**: Developer automation tools

### `/docs/` - Documentation (Diátaxis)

```
docs/
├── tutorials/          # Learning-oriented
├── how-to/            # Goal-oriented
├── reference/         # Information-oriented
├── explanation/       # Understanding-oriented
├── adr/               # Architecture Decision Records
├── runbooks/          # Operational procedures
├── guides/            # Deep-dive guides
│   ├── agent-integration/
│   ├── security/
│   └── contribution/
├── meta/              # Documentation meta
├── index.md           # Documentation home
├── STYLE_GUIDE.md     # Writing standards
├── SESSION_LOG.md     # Continuation tracker
├── .progress.yaml     # Progress tracker
└── mcp.json           # Model Context Protocol config
```

**Purpose**: All project documentation

### `/.github/` - CI/CD

```
.github/
├── workflows/
│   ├── ci.yml              # Build, lint, test
│   ├── security.yml        # gitleaks, audit
│   ├── docs.yml            # Documentation CI
│   └── subtree-push.yml    # Mirror synchronization
└── CODEOWNERS              # PR review assignments
```

**Purpose**: GitHub Actions workflows

---

## Projects Tier: `/projects/`

### `/projects/local/` - Local Repositories

**Count**: 3 repositories

```
local/
├── flashfusion-consolidated/   # 570MB - npm monorepo
├── harvestflow/                # 217MB - TypeScript pipeline
└── int-smart-triage-ai-2.0/   # 266MB - Triage AI v2.0
```

**Characteristics**:

- No GitHub remote (local development only)
- Imported by copying (no git history)

### `/projects/krosebrook/` - Krosebrook Organization

**Count**: 34 repositories

```
krosebrook/
├── core/           # Core FlashFusion projects (10)
│   ├── flashfusion/
│   ├── flashfusionwebsite/
│   ├── flashfusion-unified/
│   ├── mono-turbo-repo-flashfusion/
│   └── theaidashboard/
├── apps/           # Applications (17)
│   ├── int-smart-triage-ai-2.0/
│   ├── int-smart-triage-ai-3.0/
│   ├── archon/
│   └── ...
└── tools/          # Development tools (7)
    ├── claude-code-dev-kit/
    ├── metamcp/
    ├── playwright-mcp/
    └── ...
```

**Characteristics**:

- Owned by @Krosebrook
- SoT canonical (changes flow SoT → mirrors)
- Mirrors at `github.com/Krosebrook/*`

### `/projects/flashfusionv1/` - FlashFusionv1 Organization

**Count**: 8 repositories

```
flashfusionv1/
├── flashfusion-creative-hub/
├── collabnet-visualizer-111/
├── pulse-robot-template-40849/
├── nimble-fab-flow/
├── loveable-supabase/
├── dyad/
├── spec-kit/
└── open-lovablev1/
```

**Characteristics**:

- Owned by @Krosebrook (flashfusionv1 org)
- SoT canonical
- Mirrors at `github.com/FlashFusionv1/*`

### `/projects/chaosclubco/` - ChaosClubCo Organization

**Count**: 8 repositories

```
chaosclubco/
├── tiktok-story-ai/
├── context7/
├── supabase-js/
├── compose-for-agents/
├── flashfusion-ide/
├── superclaude-1/
├── superclaude/
└── turborepo-flashfusion/
```

**Characteristics**:

- Owned by @Krosebrook (ChaosClubCo org)
- SoT canonical
- Mirrors at `github.com/ChaosClubCo/*`

---

## Configuration Files

### Root Files

| File                  | Purpose                 |
| --------------------- | ----------------------- |
| `package.json`        | Root workspace config   |
| `pnpm-workspace.yaml` | Workspace package list  |
| `turbo.json`          | Turbo build pipeline    |
| `tsconfig.base.json`  | Base TypeScript config  |
| `eslint.config.js`    | ESLint flat config      |
| `.prettierrc.json`    | Prettier formatting     |
| `.gitignore`          | Git ignore rules        |
| `.llms.txt`           | AI discovery index      |
| `.markdownlint.json`  | Markdown linting        |
| `renovate.json`       | Renovate config         |
| `README.md`           | Repository home         |
| `GETTING_STARTED.md`  | Quick start guide       |
| `CONTRIBUTING.md`     | Contribution guidelines |
| `SECURITY.md`         | Security policy         |
| `REPO_MAP.md`         | Repository index        |

### Workspace Configuration

**`pnpm-workspace.yaml`**:

```yaml
packages:
  - "agents/*"
  - "projects/**/*"
  - "shared/*"
```

**Purpose**: Tells pnpm which directories are workspace packages

### Build Configuration

**`turbo.json`**:

```json
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", "build/**", ".next/**"]
    }
  }
}
```

**Purpose**: Defines task execution order and caching

---

## Size Breakdown

| Directory                 | Size   | File Count |
| ------------------------- | ------ | ---------- |
| `projects/local/`         | 1.05GB | ~1,500     |
| `projects/krosebrook/`    | ~300MB | ~5,000     |
| `projects/flashfusionv1/` | ~50MB  | ~500       |
| `projects/chaosclubco/`   | ~50MB  | ~500       |
| `agents/`                 | ~1MB   | ~20        |
| `shared/`                 | ~100KB | ~10        |
| `docs/`                   | ~500KB | ~50        |
| `.github/`                | ~20KB  | ~10        |
| **Total**                 | ~1.5GB | ~7,600     |

---

## Naming Conventions

### Directory Names

- **kebab-case**: `flashfusion-consolidated`, `int-smart-triage-ai-2.0`
- **Lowercase**: `projects/`, `agents/`, `shared/`
- **Organization mirrors GitHub**: `projects/krosebrook/` matches GitHub org

### File Names

- **Markdown**: `kebab-case.md` (e.g., `workspace-structure.md`)
- **TypeScript**: `kebab-case.ts` or `PascalCase.ts` (per project)
- **Config**: `.filename` (e.g., `.gitignore`, `.llms.txt`)

---

## Path Examples

### Absolute Paths (from repo root)

```bash
/projects/local/flashfusion-consolidated/package.json
/projects/krosebrook/core/flashfusion/src/index.ts
/shared/contracts/agent-output.schema.json
/docs/tutorials/01-quickstart.md
/.github/workflows/ci.yml
```

### Relative Paths (from project)

```bash
# From /projects/local/flashfusion-consolidated/
../../shared/contracts/agent-output.schema.json
../../../docs/reference/workspace-structure.md
```

---

## Workspace Dependencies

Projects reference shared utilities using `workspace:*` protocol:

```json
{
  "dependencies": {
    "@flashfusion/logging": "workspace:*",
    "@flashfusion/contracts": "workspace:*"
  }
}
```

**Purpose**: Ensures projects always use latest local version

---

## See Also

- [CLI Reference](/docs/reference/cli-reference.md) - Commands for navigating workspace
- [SoT Canonical Model](/docs/explanation/sot-canonical-model.md) - Why this structure
- [Turbo Caching](/docs/explanation/turbo-caching-internals.md) - How builds work
- [ADR-0001: SoT Canonical](/docs/adr/0001-sot-canonical-model.md) - Architecture decision

---

**Last Updated**: 2025-10-27 | **Maintainer**: @Krosebrook
