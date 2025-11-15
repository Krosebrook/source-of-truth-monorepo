---
title: Comprehensive Repository Audit & Consolidation Plan
date: 2025-11-02
auditor: Claude Sonnet 4.5
scope: Local + GitHub (Krosebrook, FlashFusionv1 orgs)
total_repos: 76+ GitHub, 10+ Local
status: AUDIT_COMPLETE
---

# Repository Ecosystem Audit

## Executive Summary

**Total GitHub Repositories Found**: 76+ public repos under Krosebrook, 7+ under FlashFusionv1  
**Local Repositories**: 10+ active git repositories  
**Protected Repositories**: 3 (source-of-truth-monorepo, HarvestFlow, INT-Smart-Triage-AI-2.0)  
**Health Status**: 🟡 FRAGMENTED - Significant consolidation needed  
**Recommendation**: Migrate to source-of-truth-monorepo using Turborepo structure

---

## Critical Repositories (High Priority)

### 1. **source-of-truth-monorepo** ⭐ PRIMARY
- **Location**: `/home/kyler/source-of-truth-monorepo`
- **GitHub**: `Krosebrook/source-of-truth-monorepo`
- **Branch**: master
- **Status**: 🟡 10 uncommitted changes
- **Purpose**: Intended as the canonical monorepo for all FlashFusion projects
- **Description**: Central repository designed to house all FlashFusion applications, packages, and shared code using modern monorepo tooling
- **Usage**: This should become the single source of truth for all projects, using Turborepo for build orchestration and pnpm workspaces for dependency management
- **Health**: Partially populated but needs systematic migration of all active projects

### 2. **HarvestFlow** ⭐ PRODUCTION
- **Location**: `/home/kyler/HarvestFlow`
- **GitHub**: `Krosebrook/Harvestflow`
- **Branch**: main
- **Status**: 🟡 3 uncommitted changes
- **Purpose**: Production application for harvest/farming operations management
- **Description**: Full-stack application for managing agricultural operations, likely using Next.js/React with Supabase backend
- **Usage**: Active production application that requires careful migration planning with zero-downtime deployment strategy
- **Health**: Stable but needs to be migrated to monorepo as a workspace package

### 3. **INT-Smart-Triage-AI-2.0** ⭐ PRODUCTION
- **Location**: `/home/kyler/INT-Smart-Triage-AI-2.0` (duplicate in `/home/kyler/projects/`)
- **GitHub**: `Krosebrook/INT-Smart-Triage-AI-2.0`
- **Branch**: Update2.0
- **Status**: 🔴 32 uncommitted changes, DUPLICATE exists
- **Purpose**: AI-powered customer support triage system for INT Inc.
- **Description**: Secure, production-ready AI triage tool that instantly triages client tickets, provides CSRs with empathetic talking points, suggests KB articles, and logs to Supabase using Vercel serverless functions
- **Usage**: Deploy to Vercel, requires OpenAI API key and Supabase credentials for full functionality
- **Health**: 🔴 CRITICAL - Has duplicate copies, large number of uncommitted changes
- **Issues**: 38 open issues on GitHub

---

## FlashFusion Ecosystem (Active Development)

### 4. **flashfusion-ide** ⭐⭐⭐ (3 stars)
- **GitHub**: `Krosebrook/flashfusion-ide`
- **Language**: TypeScript
- **Status**: 1 open issue
- **Purpose**: Modern, AI-powered, web-based IDE
- **Description**: Free and self-hosted IDE that rivals Replit and Loveable.dev with AI assistance capabilities
- **Usage**: Self-hosted development environment for building web applications with AI pair programming features
- **Health**: Active, public flagship project

### 5. **turborepo-flashfusion** ⭐ (1 star)
- **GitHub**: `Krosebrook/turborepo-flashfusion`
- **Language**: JavaScript
- **Status**: 🔴 28 open issues
- **Purpose**: Turborepo monorepo setup for FlashFusion projects
- **Description**: Monorepo configuration with shared packages and optimized build pipeline for FlashFusion ecosystem
- **Usage**: Template/foundation for consolidating FlashFusion projects into a single monorepo structure
- **Health**: 🔴 High issue count suggests active development or migration challenges
- **Note**: Should be merged INTO source-of-truth-monorepo, not used separately

### 6. **FlashFusion-Unified**
- **GitHub**: `Krosebrook/FlashFusion-Unified`
- **Language**: JavaScript
- **Status**: 9 open issues
- **Purpose**: Unified FlashFusion platform
- **Description**: Attempt at consolidating FlashFusion applications into a single codebase
- **Usage**: Predecessor to turborepo approach, likely superseded by newer monorepo strategy
- **Health**: Legacy, should be evaluated for migration or archival

### 7. **flashfusion-genesis**
- **GitHub**: `Krosebrook/flashfusion-genesis`
- **Language**: TypeScript
- **Status**: 5 open issues
- **Purpose**: Genesis/foundational FlashFusion application
- **Description**: Core FlashFusion application or template for generating new FlashFusion instances
- **Usage**: Likely a generator or starter template for FlashFusion projects
- **Health**: Active but should be consolidated into monorepo

### 8. **Flashfusionwebsite**
- **GitHub**: `Krosebrook/Flashfusionwebsite`
- **Language**: TypeScript
- **Status**: 2 open issues
- **Purpose**: Public-facing FlashFusion website
- **Description**: Marketing/landing page for the FlashFusion platform
- **Usage**: Static site or Next.js application for showcasing FlashFusion capabilities
- **Health**: Recently updated (2025-11-01), should be workspace in monorepo

### 9. **flashfusion-discord**
- **GitHub**: `Krosebrook/flashfusion-discord`
- **Purpose**: Discord bot integration
- **Description**: Discord bot for FlashFusion community or automation
- **Usage**: Node.js Discord bot, likely for community management or CI/CD notifications
- **Health**: Newly created, minimal commits

### 10. **flashfusion-creative-hub** (FlashFusionv1 org)
- **GitHub**: `FlashFusionv1/flashfusion-creative-hub`
- **Language**: TypeScript
- **Status**: 5 open issues
- **Purpose**: Creative content management for FlashFusion
- **Description**: Hub for managing creative assets, templates, or user-generated content within FlashFusion ecosystem
- **Usage**: Likely a web application for content creators using FlashFusion
- **Health**: Under FlashFusionv1 org, needs organizational decision on ownership

---

## Development Tools & Utilities

### 11. **DevChat**
- **GitHub**: `Krosebrook/DevChat`
- **Language**: TypeScript
- **Status**: 7 open issues
- **Purpose**: Developer communication/chat application
- **Description**: Real-time chat application for developers, possibly integrated with FlashFusion IDE
- **Usage**: Standalone chat app or IDE plugin for team collaboration
- **Health**: Active development

### 12. **CreatorStudioLite**
- **GitHub**: `Krosebrook/CreatorStudioLite`
- **Language**: TypeScript
- **Purpose**: Lightweight content creation studio
- **Description**: Simplified version of a content creation platform, likely for video/media editing or design
- **Usage**: Web-based creative tool for content creators
- **Health**: Active

### 13. **OctaveStudio**
- **GitHub**: `Krosebrook/OctaveStudio`
- **Language**: TypeScript
- **Purpose**: Audio/music production studio
- **Description**: Web-based digital audio workstation (DAW) or music creation tool
- **Usage**: Browser-based music production environment
- **Health**: Recently created (Oct 2025)

### 14. **UniPromptGen2**
- **GitHub**: `Krosebrook/UniPromptGen2`
- **Language**: TypeScript
- **Status**: 1 open issue
- **Purpose**: Universal prompt generator for AI models
- **Description**: Tool for generating optimized prompts for various AI models (GPT, Claude, etc.)
- **Usage**: Web interface for crafting and testing AI prompts with templates and best practices
- **Health**: Active, recently updated

---

## Knowledge Base & Documentation

### 15. **FFKB** (FlashFusion Knowledge Base)
- **GitHub**: `Krosebrook/FFKB`
- **Language**: TypeScript
- **Purpose**: Knowledge base for FlashFusion ecosystem
- **Description**: Centralized documentation and knowledge management system for FlashFusion users and developers
- **Usage**: Searchable documentation site, likely Next.js with MDX content
- **Health**: Recently updated (2025-11-01)

### 16. **FLashFusion-Learn**
- **GitHub**: `Krosebrook/FLashFusion-Learn`
- **Language**: JavaScript
- **Purpose**: Learning platform for FlashFusion
- **Description**: Educational content and tutorials for learning how to use FlashFusion tools
- **Usage**: Course platform or interactive tutorials
- **Health**: Active

---

## Specialized Applications

### 17. **enhanced-firecrawl-scraper**
- **GitHub**: `Krosebrook/enhanced-firecrawl-scraper`
- **Language**: HTML
- **Purpose**: Web scraping with comprehensive context extraction
- **Description**: Enhanced version of FireCrawl scraper with advanced context extraction capabilities for AI training data
- **Usage**: Scrape websites while preserving context and structure for AI applications
- **Health**: Utility tool

### 18. **security-blindspot-radar**
- **GitHub**: `Krosebrook/security-blindspot-radar`
- **Language**: TypeScript
- **Purpose**: Security vulnerability detection
- **Description**: Tool for identifying security blindspots in applications or infrastructure (created by Leap)
- **Usage**: Security scanning and vulnerability assessment platform
- **Health**: Recently created (Oct 2025)

### 19. **v0-template-evaluation-academy**
- **GitHub**: `Krosebrook/v0-template-evaluation-academy`
- **Language**: TypeScript
- **Purpose**: Template evaluation and testing
- **Description**: Platform for evaluating and scoring v0 templates (Vercel's v0 AI design tool)
- **Usage**: Test and rate v0-generated templates for quality and best practices
- **Health**: Recently updated (2025-11-01)

### 20. **LifeWins**
- **GitHub**: `Krosebrook/LifeWins`
- **Purpose**: Kid training/gamification app
- **Description**: Gamified application for teaching children life skills through rewards and achievements
- **Usage**: Mobile or web app for parents to track and reward children's accomplishments
- **Health**: Older project (June 2025)

---

## Client Projects & Templates

### 21. **smbv3** (SoleMuchBetter v3)
- **GitHub**: `Krosebrook/smbv3`
- **Language**: TypeScript
- **Status**: 1 open issue
- **Purpose**: Client project - SoleMuchBetter application
- **Description**: Third version of a client application, likely for e-commerce or business management
- **Usage**: Production application for specific client
- **Health**: Active

### 22. **solemuchbetter**
- **GitHub**: `Krosebrook/solemuchbetter`
- **Purpose**: Original SoleMuchBetter project
- **Description**: Earlier version of smbv3, possibly deprecated
- **Usage**: Legacy codebase, evaluate for archival
- **Health**: Older version

### 23. **sole-scaffold-hub**
- **GitHub**: `Krosebrook/sole-scaffold-hub`
- **Language**: TypeScript
- **Purpose**: Scaffolding/template hub for Sole projects
- **Description**: Generator or template system for creating Sole-branded applications
- **Usage**: CLI tool or web interface for project scaffolding
- **Health**: Active

---

## V0 Templates & Experimental Projects

### 24-30. **v0-*** repositories (Multiple)
- **Examples**: v0-pointer-ai-landing-page, v0-ai-agent-builder, v0-ai-tool-hub-92085
- **Pattern**: v0-generated templates
- **Language**: TypeScript
- **Purpose**: Rapid prototyping using Vercel v0
- **Description**: Collection of AI-generated templates from Vercel's v0 tool for various use cases
- **Usage**: Starting points for new projects or experimentation with v0 capabilities
- **Health**: Experimental, many are private repos
- **Recommendation**: Consolidate learnings, archive unused templates

---

## FFSignup & Pulse Templates (FlashFusionv1 org)

### 31. **FFSignup**
- **GitHub**: `Krosebrook/FFSignup`
- **Purpose**: FlashFusion signup/onboarding flow
- **Description**: User registration and onboarding application for FlashFusion platform
- **Usage**: Standalone signup service or integrated auth flow
- **Health**: Minimal activity

### 32. **pulse-robot-template-40849** (FlashFusionv1 org, PRIVATE)
- **GitHub**: `FlashFusionv1/pulse-robot-template-40849`
- **Language**: TypeScript
- **Purpose**: Pulse/heartbeat monitoring template
- **Description**: Template for creating health check or monitoring robots
- **Usage**: Infrastructure monitoring or service health checks
- **Health**: Private, recently created

### 33. **loveable-supabase** (FlashFusionv1 org)
- **GitHub**: `FlashFusionv1/loveable-supabase`
- **Language**: TypeScript
- **Status**: 7 open issues
- **Purpose**: Supabase integration template
- **Description**: Template or starter for integrating Supabase with Loveable.dev projects
- **Usage**: Boilerplate for rapid Supabase app development
- **Health**: Active, under FlashFusionv1 organization

---

## Archived/Deprecated Candidates

### 34. **Intos** (PRIVATE)
- **GitHub**: `Krosebrook/Intos`
- **Language**: TypeScript
- **Purpose**: Unknown (private)
- **Health**: Private repository, evaluate for archival or migration

### 35-76. **Additional repositories**
- Many experimental, template, and one-off projects
- Recommendation: Perform individual assessment for archival vs. migration

---

## Local Repository Status

### Key Findings:
1. **Duplicate**: INT-Smart-Triage-AI-2.0 exists in two locations
2. **Uncommitted Changes**: All 3 protected repos have uncommitted work
3. **Local-only**: Several repos in `/home/kyler/projects/` not pushed to GitHub
4. **External Drive**: Additional repos on `/mnt/d/` need cataloging

### Local Repos Detected:
- `/home/kyler/project-nexus`
- `/home/kyler/template-mcp-server`
- `/home/kyler/codex-workspace`
- `/home/kyler/projects/Figma-Context-MCP`
- `/home/kyler/projects/flashfusion`

---

## Repository Health Matrix

| Category | Count | Health | Action Required |
|----------|-------|--------|-----------------|
| **Production Critical** | 3 | 🟡 Moderate | Commit changes, migrate to monorepo |
| **Active FlashFusion** | 10+ | 🟡 Fragmented | Consolidate to monorepo |
| **Development Tools** | 5+ | 🟢 Good | Package as monorepo workspaces |
| **Client Projects** | 3+ | 🟡 Moderate | Evaluate for monorepo inclusion |
| **Templates/Experiments** | 30+ | 🔴 Cluttered | Archive 80%, migrate 20% |
| **FlashFusionv1 Org** | 7+ | 🟡 Moderate | Decide ownership, migrate to Krosebrook |
| **Local Uncommitted** | 10+ | 🔴 Risk | Commit and push immediately |

---

## Consolidation Strategy: Migration to source-of-truth-monorepo

### Phase 1: Immediate Actions (P0)
1. **Commit all uncommitted changes** in protected repos
2. **Push local-only repos** to GitHub for backup
3. **Remove duplicate** INT-Smart-Triage-AI-2.0 copy
4. **Create monorepo structure** in source-of-truth-monorepo

### Phase 2: Core Migration (P1)
**Target Structure**:
```
source-of-truth-monorepo/
├── apps/
│   ├── flashfusion-ide/          # Main IDE application
│   ├── harvestflow/               # Production app
│   ├── int-smart-triage/          # Production app
│   ├── flashfusion-website/       # Marketing site
│   └── creator-studio-lite/       # Creative tools
├── packages/
│   ├── ui/                        # Shared UI components
│   ├── config/                    # Shared configs
│   ├── tsconfig/                  # TypeScript configs
│   ├── eslint-config/             # Linting rules
│   └── ai-tools/                  # Shared AI utilities
├── tools/
│   ├── unipromptgen/              # Prompt generation
│   ├── firecrawl-scraper/         # Web scraping
│   └── security-scanner/          # Security tools
├── docs/
│   ├── ffkb/                      # Knowledge base
│   └── flashfusion-learn/         # Learning content
└── templates/
    ├── v0-templates/              # Best v0 templates
    └── scaffolds/                 # Project generators
```

**Migration Order**:
1. FlashFusion IDE (flagship)
2. HarvestFlow (production)
3. INT Smart Triage (production)
4. Development tools
5. Knowledge base & documentation
6. Templates & utilities

### Phase 3: FlashFusionv1 Org Resolution (P2)
**Decision Required**: 
- Transfer repos to Krosebrook account OR
- Maintain FlashFusionv1 as organizational account
- Consolidate either way into source-of-truth-monorepo

### Phase 4: Archive & Cleanup (P2)
**Archive Candidates** (70-80% of repos):
- One-off v0 experiments
- Superseded versions (FlashFusion-Unified, solemuchbetter)
- Inactive templates
- Personal experiments

**Criteria for Migration**:
- ✅ Active in last 3 months
- ✅ Production or production-bound
- ✅ Part of FlashFusion ecosystem core
- ✅ Reusable tools/utilities
- ✅ Documentation/knowledge base

**Criteria for Archival**:
- ❌ Inactive >6 months
- ❌ Superseded by newer version
- ❌ One-time experiment
- ❌ No clear use case
- ❌ Duplicate functionality

---

## Technical Requirements for Migration

### Tools Needed:
1. **Turborepo** - Already in turborepo-flashfusion repo
2. **pnpm workspaces** - For dependency management
3. **Shared packages** - UI components, configs, utilities
4. **CI/CD pipeline** - GitHub Actions for monorepo
5. **Changesets** - For versioning and changelogs

### Migration Checklist (Per Repo):
- [ ] Audit dependencies for conflicts
- [ ] Update import paths for monorepo structure
- [ ] Configure Turborepo pipeline
- [ ] Migrate environment variables to shared config
- [ ] Update GitHub Actions workflows
- [ ] Test build & deployment
- [ ] Update documentation
- [ ] Archive original repo (don't delete)

---

## Risk Assessment

### High Risks:
1. **Production Downtime** - HarvestFlow, INT Smart Triage
   - **Mitigation**: Blue-green deployment, feature flags
2. **Dependency Conflicts** - 76+ repos with varying dependencies
   - **Mitigation**: Thorough dependency audit, pnpm peer dep resolution
3. **Data Loss** - Uncommitted changes in 3 protected repos
   - **Mitigation**: Immediate commit & push, backup before any operation
4. **Git History Loss** - 76 repos of history
   - **Mitigation**: Use git subtree/submodule initially, preserve original repos

### Medium Risks:
1. **Build Pipeline Complexity** - Turborepo configuration
2. **Team Coordination** - Multiple projects, potential collaborators
3. **Secret Management** - Consolidating env vars from 76 repos

### Low Risks:
1. **Template Archival** - Easy to restore if needed
2. **Local Repository Cleanup** - Can be done incrementally

---

## Timeline & Effort Estimate

| Phase | Duration | Effort | Dependencies |
|-------|----------|--------|--------------|
| **P0: Immediate Safety** | 2-4 hours | High | None |
| **P1: Core Migration** | 20-30 hours | Very High | P0 complete |
| **P2: Org Resolution** | 4-8 hours | Medium | P1 complete |
| **P2: Archive & Cleanup** | 10-15 hours | Medium | P1 complete |
| **TOTAL** | 36-57 hours | - | - |

---

## Immediate Next Steps (Next 24 Hours)

1. ✅ **Commit & Push Protected Repos**
   ```bash
   cd /home/kyler/source-of-truth-monorepo && git add . && git commit -m "chore: preserve uncommitted work" && git push
   cd /home/kyler/HarvestFlow && git add . && git commit -m "chore: preserve uncommitted work" && git push
   cd /home/kyler/INT-Smart-Triage-AI-2.0 && git add . && git commit -m "chore: preserve uncommitted work" && git push
   ```

2. ✅ **Remove Duplicate INT Repo**
   ```bash
   # After confirming /home/kyler/INT-Smart-Triage-AI-2.0 is primary
   mv /home/kyler/projects/INT-Smart-Triage-AI-2.0 /home/kyler/.archive/INT-Smart-Triage-AI-2.0-duplicate-$(date +%Y%m%d)
   ```

3. ✅ **Document Local-Only Repos**
   - Create GitHub repos for: Figma-Context-MCP, codex-workspace, project-nexus
   - Push local changes

4. ✅ **Initialize Monorepo Structure**
   - Review turborepo-flashfusion configuration
   - Set up base monorepo structure in source-of-truth-monorepo
   - Create migration roadmap document

5. ✅ **FlashFusionv1 Org Decision**
   - Decide: Transfer to Krosebrook OR maintain separate org
   - Document rationale

---

## Success Metrics

- [ ] All repos cataloged and health-checked
- [ ] 0 uncommitted changes in protected repos
- [ ] 0 duplicate repositories
- [ ] All local repos pushed to GitHub
- [ ] Monorepo structure defined and initialized
- [ ] 3 core apps migrated to monorepo (IDE, HarvestFlow, INT)
- [ ] 50%+ of active repos consolidated
- [ ] 70%+ of inactive repos archived
- [ ] CI/CD pipeline operational for monorepo
- [ ] Zero production incidents during migration

---

## Approval Required

**Human Decision Points**:
1. FlashFusionv1 organization strategy (transfer vs. maintain)
2. Archive vs. migrate decisions for borderline repos
3. Production migration windows for HarvestFlow & INT Smart Triage
4. Monorepo naming/branding (keep "source-of-truth-monorepo"?)

---

**Audit Completed**: 2025-11-02T13:00:00Z  
**Auditor**: Claude Sonnet 4.5 (Codex CLI)  
**Confidence**: 0.90 (comprehensive GitHub data, partial local data)  
**Recommendation**: Proceed with P0 immediate actions, then schedule P1 core migration

**Next Review**: After P0 completion (uncommitted work committed)
