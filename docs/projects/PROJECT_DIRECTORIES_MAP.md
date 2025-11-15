# Project Directories & File Structure Map

**Generated**: November 15, 2025
**Last Migration**: November 15, 2025 (home-kyler-consolidation)

## Source of Truth Monorepo Structure

This monorepo is now the **canonical source** for all active projects following the comprehensive migration from `/home/kyler` on November 15, 2025.

### Monorepo Organization (`/home/kyler/source-of-truth-monorepo`)

```
source-of-truth-monorepo/
├── projects/
│   ├── krosebrook/          # User-owned projects
│   │   ├── apps/            # Applications
│   │   │   └── project-nexus/
│   │   └── tools/           # Development tools
│   │       ├── codex-workspace/
│   │       ├── figma-context-mcp/
│   │       └── template-mcp-server/
│   └── local/               # Imported/local projects
│       ├── flashfusion-consolidated/
│       ├── harvestflow/
│       ├── int-smart-triage-ai-2.0/
│       └── mcp-cloud-demo/
├── docs/                    # Documentation (72+ files, ~1MB)
│   ├── flashfusion/         # FlashFusion-specific docs
│   ├── governance/          # Compliance and policies
│   ├── planning/            # Sprint plans and audits
│   ├── projects/            # Project metadata
│   ├── reports/             # Validation and status reports
│   └── sessions/            # Session continuity logs
├── scripts/                 # Automation and tooling
│   └── infrastructure/      # Infrastructure automation
│       ├── automation/      # Python, TypeScript, Shell scripts
│       └── scripts/         # Stripe, Docker, checkpoint scripts
├── workspace-meta/          # Workspace metadata (~35MB)
│   ├── agents/              # Agent prompts and registry
│   ├── artefacts/           # SBOM, signatures
│   ├── ops/                 # Capability token registry
│   ├── policy-packs/        # GDPR, HIPAA, SOX, CCPA policies
│   └── runbooks/            # Operational runbooks
├── .claude-custom/          # Claude agent skills (~188KB)
│   ├── agents/              # AI orchestrator, API designer, etc.
│   └── skills/              # 10+ specialized skills
└── .cline/                  # Cline workflow configurations
```

---

## Project Inventory

### Krosebrook Apps (`projects/krosebrook/apps/`)

#### **project-nexus** (~1.5MB)
- **Tech**: Encore.dev backend, Vite frontend, TypeScript
- **Purpose**: Project management hub with deployment automation
- **Features**: Deployment pipelines, alerting, collaboration, backup/restore
- **Status**: ✅ Migrated November 15, 2025

### Krosebrook Tools (`projects/krosebrook/tools/`)

#### **codex-workspace** (~16KB)
- **Tech**: Codex CLI workspace
- **Purpose**: Development workspace and documentation management
- **Status**: ✅ Migrated November 15, 2025

#### **figma-context-mcp** (~893KB)
- **Tech**: TypeScript, MCP protocol
- **Purpose**: Figma Model Context Protocol server
- **Origin**: Forked from GLips/Figma-Context-MCP → Krosebrook/Figma-Context-MCP
- **Status**: ✅ Forked and migrated November 15, 2025

#### **template-mcp-server** (~121KB)
- **Tech**: TypeScript, MCP protocol
- **Purpose**: MCP server template and generator
- **Origin**: Forked from mcpdotdirect/template-mcp-server → Krosebrook/template-mcp-server
- **Status**: ✅ Forked and migrated November 15, 2025

### Local Projects (`projects/local/`)

#### **flashfusion-consolidated**
- **Tech**: Turbo monorepo, apps/, packages/, tools/
- **Purpose**: FlashFusion AI ecosystem
- **Status**: ✅ Active development
- **Notes**: Historical backup archived (699MB → 136MB tarball)

#### **harvestflow** (~743KB)
- **Tech**: Turbo monorepo, pnpm workspaces, TypeScript
- **Purpose**: Data pipeline and dashboard system
- **Structure**: apps/ (dashboard), packages/ (chat-history, shared, core)
- **Features**: Agent workflows, drift protection, semantic guards
- **Status**: ✅ Updated with canonical version (Oct 27 22:46)
- **Previous versions**: 3 copies resolved, active-projects version chosen

#### **int-smart-triage-ai-2.0** (~4.5MB)
- **Tech**: Vite, Supabase, Vercel deployment
- **Purpose**: AI triage tool for INT Inc
- **Features**: CI/CD, internal notes, client history, analytics
- **Status**: ✅ Updated with canonical version (Update2.0 branch, Oct 16)
- **Previous versions**: 2 copies resolved, active-projects version chosen

#### **mcp-cloud-demo** (~168KB)
- **Tech**: TypeScript, MCP, Kubernetes
- **Purpose**: MCP server cloud deployment demo
- **Features**: Docker, K8s manifests, HPA, Ingress
- **Status**: ✅ Migrated November 15, 2025

---

## Primary Development Locations

### D Drive: Main Development Hub

#### `/mnt/d/Projects/Active` - Active Project Repository
- **turborepo-flashfusion** - Monorepo build system (Turbo 2.3.0)
- **krosebrook-turborepo** - Master monorepo (Turbo 2.5.6, pnpm 9.0.0)
  - Contains: apps/, packages/, tools/ workspaces
  - MCP servers collection
- **FlashFusion-Enterprise** - Enterprise AI system (16 microservices)
  - `/pydantic-ai-orchestrator` - Python 3.13, FastAPI, Pydantic AI
  - `/git-platform-automator` - GitHub/GitLab automation
  - `/langfuse-telemetry-hub` - LLM observability
  - `/enterprise-oauth-manager` - OAuth for 20+ services
  - `/saas-service-hub` - Centralized SaaS management
  - `/mobile-devops-orchestrator` - Firebase integration
  - `/claude-workflow-automator` - Workflow builder
  - `/codebase-intelligence-analyzer` - Code analysis
  - `/ai-docs-generator` - Auto documentation
  - `/env-secrets-orchestrator` - Secrets management
  - `/webhook-event-processor` - GitHub/GitLab webhooks
  - `/scheduled-analysis-engine` - Batch processing
  - `/unified-analytics-engine` - Performance metrics
  - `/agent-knowledge-persistence` - Memory backend
  - `/system-performance-monitor` - Resource tracking
  - `/enterprise-security-hub` - SOC 2/GDPR compliance
  - `docker-compose.yml` - Infrastructure setup
  - `manage-system.py` - Python system manager
  - `start-all.sh` - Service startup script

- **chaoscollective-enterprise** - Enterprise monorepo (@chaoscollective/enterprise-monorepo)
  - Turbo 2.3.0, pnpm 9.0.0, Playwright, Jest, Biome
  - Multi-stage deployment (staging, production)

- **supabase-erp-app** - SvelteKit ERP application
  - SvelteKit 2.36.1, Svelte 5.38.2, Vite 7.1.3
  - Supabase PostgreSQL + Redis

- **mcp-servers** - Model Context Protocol Server Collection
  - 18+ custom MCP server implementations
  - Key servers: Figma, AWS, MongoDB, GitHub, Notion, Playwright, Firecrawl

- **ai-cli-router** & **ai-cli-router-portable** - AI CLI routing tools
  - Intelligent Claude/Gemini/Codex selection
  - 94.7% classification accuracy

- **api-integration-hub** - API testing dashboard
- **claude-multi-agent-system** - Multi-agent coordination
- **app-icon-manager** - Icon management system
- **my-pwa-app** - Progressive Web App

#### `/mnt/d/01_Projects/Active` - Alternative Project Hub
- **FlashFusion_Ecosystem** (4 variants)
  - `FlashFusion_TurboRepo/` - Latest monorepo
  - `FlashFusion_Main/` - Primary implementation
  - `FlashFusion_V1/` - Original version
  - `FlashFusion_Website/` - Public site
  - Tech: React, Express, Drizzle ORM, Neon, Radix UI

- **AuthConnect** - Authentication system
  - TypeScript/Express/Drizzle ORM/Radix UI

- **DevChat** - Communication tool
- **SpudSignup** - Registration system
- **SuperDesign** - Design system

#### `/mnt/d/Projects/ERP-Systems` - ERP Implementations
- **erpnext/** - Full ERP suite
- **ErpNet.FP/** - Financial planning
- **InvenTree/** - Inventory management
- **carbon/** - Sustainability tracking
- **order-management-system/**
- **Inventory-Management-System/**
- **stock-logistics-workflow/**
- **PIPrint/** - Print management
- **printmaster/** - Advanced printing

#### `/mnt/d/03_Development` - Development Infrastructure
- **Dependencies/** - Shared dependencies
- **Packages/** - Package configurations
- **Scripts/** - Automation scripts
- **Tools/** - Development tools
- **Temp/** - Temporary files

#### `/mnt/d/04_Documentation` - Documentation Hub
- **Personal_Docs/** - Personal documentation
- **Personal_Notes/** - Personal notes
- **Project_Docs/** - Project documentation
- **Technical_Docs/** - Technical reference

#### `/mnt/d/05_Resources` - Resource Library
- **Assets/** - Design assets, images
- **Installers/** - Tool installers
- **Libraries/** - Code libraries

#### `/mnt/d/06_Knowledge_Base` - Knowledge Repository
- Research notes, documentation, learning materials

---

### C Drive: User Configuration & Tools

#### `/mnt/c/Users/kyler` - User Home Directory
- **.aws/** - AWS configuration and credentials
  - `config` - AWS regions
  - `credentials` - AWS credentials
  - `sso/` - SSO configuration
  - `amazonq/` - Amazon Q (IDE integration)

- **.azure/** - Azure CLI configuration
  - `azureProfile.json` - Azure profile
  - `clouds.config` - Cloud configuration
  - Telemetry and command logs

- **.docker/** - Docker configuration

- **.claude/** - Claude configuration directory
  - `.claude.json` - Configuration file (220KB)

- **.aws/** - AWS tools

- **.bun/** - Bun runtime configuration

- **.cache/** - Cached files

- **.nvm/** - Node Version Manager data

- **.autogenstudio/** - AutoGen Studio configuration

- **.codeium/** - Codeium AI IDE plugin

- **.codegpt/** - CodeGPT configuration

- **.codex/** - Codex configuration

- **.coding/** - Coding tools configuration

- **AppData/Local/Programs/**
  - `Cursor/` - Cursor AI editor (190MB executable)
  - `Windsurf/` - Windsurf AI editor
  - `LM Studio/` - Local LLM runtime
  - `Ollama/` - Ollama local models
  - `Notion/` - Notion desktop
  - `Taskade/` - Taskade application
  - `Microsoft VS Code/` - VS Code IDE
  - `Canva/` - Canva web client
  - `Kiro/` - Kiro tool
  - `Common/` - Common tools

#### `/mnt/c/Users/kyler/Desktop` - Desktop Contents
- **Documentation & Analysis**
  - `COMPREHENSIVE_TOOLS_INVENTORY.md` - 100+ tools documented
  - `Directory_Documentation.md` - Directory structure
  - `Comprehensive-Development-Structure.md`
  - `Project-Blueprint-Diagrams.md`

- **FlashFusion Documentation**
  - `FlashFusion_Documentation/` - Complete docs folder
  - `FlashFusion-Enterprise-README.md` - Enterprise setup
  - `FlashFusion-Project-Checkpoint.md` - Project status
  - `FlashFusion-Angular-UI-Script.md`
  - `FlashFusion_Zapier_Integrations_Complete.csv`
  - `FlashFusion-Complete-Startup.bat`
  - `FlashFusion-Launcher.bat`
  - `FlashFusion-United.lnk` - Shortcut to main

- **AI & Automation**
  - `Enterprise-AI-Automation/` - AI automation folder
  - `NOTION_ZAPIER_MASTER_SETUP.md`
  - `FREE_NOTION_AUTOMATION_SETUP.md`
  - `MASTER_CHECKPOINT_2025_07_30.md`

- **SVG Architecture Diagrams**
  - `agent_dashboard_wireframe.svg`
  - `blindspot_mobile_mockups.svg`
  - `browser_extension_etl.svg`
  - `decision_matrix_tree.svg`
  - `flashfusion_ecosystem.svg`
  - `validator_pipeline.svg`

- **Configuration & Shortcuts**
  - `Apps Dashboard.html`
  - `Launch Local Apps.bat`
  - `services.html`
  - `Zapier Management.html`

#### `/mnt/c/Users/kyler/Downloads` - Active Downloads (Sep-Oct 2025)
- **Installation Files**
  - `Claude-Setup-x64.exe` (126MB)
  - `Taskade_Setup_4.6.13.exe` (181MB)
  - `BLACKBOXAI-Agent-install-win32-v1.2.4.exe` (211MB)
  - `BLACKBOXAI-Installer-v2-x64.exe` (110MB)
  - `MSTeamsSetupx64_s_8DE0C0C7C410656-3-0_c_w_.exe` (1.4GB)

- **Project Archives & Exports**
  - `ReplitExport-kylerosebrook.tar.gz` (249MB)
  - `flashfusion_reconstructed_production_repo.zip` (3.7GB)
  - `flashfusion_repopulated.zip` (3.8GB)
  - `template-academy.zip` (3.1GB)
  - Multiple project-bolt exports

- **Automation & Integration**
  - `ai-agents-workflow.zip`
  - `notion_updater_package_full.zip`
  - `flashfusion-scaffold.zip`
  - `flashfusion-agent-integration-blueprint.zip`
  - `int-triage-hardening-bundle.zip`
  - `notion_payloads_v1.zip`

- **Documentation & Guides**
  - `AI-AGENTS-WORKFLOW-GUIDE.md`
  - `EXAMPLE-USE-CASES.md`
  - `SKILL.md` - Claude Code skill definition
  - `mcp-servers.md` - MCP server documentation
  - `multi-llm-patterns.md`
  - `claude-agent-deployment-guide.md`

- **Interview & Job Prep Materials**
  - `INT_CSR_Playbook_v4.docx`
  - `INT_Inc_Client_Success_Interview_Prep_Full.docx`
  - `INT_Inc_Culture_Interview_Playbook_v4_Master.docx`
  - Multiple INT_ClientSuccessRep exercises

- **AI Training Resources**
  - Chat history archives (.zip)
  - NotebookLM mind maps (PNG)
  - AI image generations
  - Grok video files (MP4)

- **Utilities & Scripts**
  - `extract_prompt_library.py` - Python script
  - `init_mcp_server.py` - MCP initialization
  - `langgraph_nodes.py` - LangGraph components
  - `triage_tool.py` - Triage implementation
  - `int_spart_triage_service.py`

---

## Key Configuration Files

### Build & Package Configuration
```
/mnt/d/Projects/Active/{project}/
├── package.json - NPM/Node configuration
├── tsconfig.json - TypeScript configuration
├── turbo.json - Turbo monorepo config
├── pnpm-workspace.yaml - pnpm workspaces
└── .github/
    └── workflows/ - GitHub Actions CI/CD
```

### Python Projects
```
/mnt/d/Projects/Active/FlashFusion-Enterprise/{service}/
├── pyproject.toml - Python project config
├── requirements.txt - Dependencies
├── src/ - Source code
└── static/ - Static assets
```

### Docker Infrastructure
```
/mnt/d/Projects/Active/FlashFusion-Enterprise/
├── docker-compose.yml - Multi-container orchestration
└── Dockerfile - Container definitions
```

### Environment & Secrets
```
~/.aws/
  ├── config - AWS configuration
  ├── credentials - AWS credentials
  └── sso/ - SSO configuration

~/.azure/
  ├── azureProfile.json - Azure profile
  └── clouds.config - Cloud settings

~/.ssh/ - SSH keys for Git/cloud access
```

---

## Development Workflows

### Monorepo Development
```bash
cd /mnt/d/Projects/Active/krosebrook-turborepo
pnpm install
turbo run dev
turbo run build
turbo run test
```

### Python AI Development
```bash
cd /mnt/d/Projects/Active/FlashFusion-Enterprise/pydantic-ai-orchestrator
python -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
uvicorn src.main:app --reload
```

### Docker Services
```bash
cd /mnt/d/Projects/Active/FlashFusion-Enterprise
docker-compose up -d
docker-compose logs -f
```

---

## Absolute Path Reference

All paths in this document use Linux/WSL paths:
- Windows `C:` → `/mnt/c`
- Windows `D:` → `/mnt/d`
- Home directory → `/home/kyler`

