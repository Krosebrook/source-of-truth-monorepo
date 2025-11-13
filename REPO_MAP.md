# Repository Map

Complete index of repositories in the FlashFusion SoT monorepo.

**Current Status**: 3 local repositories imported, 50 GitHub repositories pending import.

## Summary

- **Local**: 3 repos ✅ _Imported_
- **Krosebrook**: 34 repos ⏳ _Pending import_
- **flashfusionv1**: 8 repos ⏳ _Pending import_
- **ChaosClubCo**: 8 repos ⏳ _Pending import_
- **Total**: 53 repos (3 imported, 50 pending)

## Migration Status

### ✅ Phase 1: Local Repositories (Complete)

These repositories have been imported into the monorepo:

1. **`projects/local/flashfusion-consolidated`** - Local consolidated FlashFusion monorepo
   - Status: Imported ✅
   - Path: `/projects/local/flashfusion-consolidated`
   - Description: Consolidated FlashFusion projects with apps, packages, and database components

2. **`projects/local/harvestflow`** - HarvestFlow pipeline
   - Status: Imported ✅
   - Path: `/projects/local/harvestflow`
   - Description: HarvestFlow data pipeline and dashboard

3. **`projects/local/int-smart-triage-ai-2.0`** - INT Smart Triage AI v2.0
   - Status: Imported ✅
   - Path: `/projects/local/int-smart-triage-ai-2.0`
   - Description: Intelligent Smart Triage AI system version 2.0

### ⏳ Phase 2: GitHub Repositories (Pending Import)

The following 50 repositories are ready to be imported using the import script:

#### Krosebrook Core Repositories (27 repos - Pending)

_To be imported from github.com/Krosebrook organization_

- List will be populated after import using `./scripts/import-github-repos.sh`
- See `scripts/repo-list.txt` for complete list

#### Krosebrook Tools Repositories (7 repos - Pending)

_To be imported from github.com/Krosebrook organization_

- List will be populated after import

#### flashfusionv1 Repositories (8 repos - Pending)

_To be imported from github.com/flashfusionv1 organization_

- List will be populated after import

#### ChaosClubCo Repositories (8 repos - Pending)

_To be imported from github.com/ChaosClubCo organization_

- List will be populated after import

---

## How to Import Remaining Repositories

To import the remaining 50 GitHub repositories:

```bash
# Run the import script
./scripts/import-github-repos.sh

# Then install dependencies
pnpm install

# Build everything
pnpm build
```

See the [Importing Repositories Tutorial](/docs/tutorials/02-importing-repos.md) for detailed instructions.

---

## Current Repository Structure

```
projects/
├── local/                          # 3 repos ✅ IMPORTED
│   ├── flashfusion-consolidated/   # Local consolidated monorepo
│   ├── harvestflow/                # HarvestFlow pipeline
│   └── int-smart-triage-ai-2.0/    # Smart Triage AI v2.0
├── krosebrook/                     # 34 repos ⏳ PENDING
│   ├── core/                       # Core FlashFusion projects
│   ├── apps/                       # Applications
│   └── tools/                      # Development tools
├── flashfusionv1/                  # 8 repos ⏳ PENDING
└── chaosclubco/                    # 8 repos ⏳ PENDING
```

---

## Infrastructure Status

### ✅ Completed

- [x] Documentation structure (Diátaxis framework)
- [x] CI/CD workflows (ci.yml, security.yml, docs.yml)
- [x] Deploy keys infrastructure (subtree-push.yml)
- [x] Import script ready (`scripts/import-github-repos.sh`)
- [x] Package management (pnpm workspaces)
- [x] Build system (Turborepo)

### ⏳ Pending

- [ ] Import 50 GitHub repositories
- [ ] Configure deploy keys for mirror sync
- [ ] Test full monorepo build
- [ ] Publish first packages

---

_This file will be auto-generated after all repos are imported using the import script._

**Last Updated**: 2025-11-01
