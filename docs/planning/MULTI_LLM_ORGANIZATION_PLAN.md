---
title: Multi-LLM File Organization Plan
version: 1.1.0
status: APPROVED - READY FOR EXECUTION
created: 2025-10-20
last_updated: 2025-10-20
author: Claude (Anthropic) + Architect Agent
approver: Kyler Rosebrook
project_id: ORG-2025-10-20
estimated_duration: 6.5 hours
---

# Multi-LLM File Organization Plan

**🎯 Mission**: Organize 32,000+ fragmented files across multiple locations using a 6-LLM collaborative system with zero-conflict guarantees.

**📊 Scope**: 8 home files + 62 Desktop items (5GB) + 31,672 UNSORTED files (2.8GB) + 9GB caches + scattered documentation

**💾 Expected Recovery**: 10-15GB disk space | **⏱️ Total Time**: ~6.5 hours

---

## Change Log

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2025-10-20 | Initial plan created | Claude + Architect Agent |
| 1.1.0 | 2025-10-20 | Added Gemini-2, split documentation (Zone 3) and downloads (Zone 4) between Gemini-1 and Gemini-2; reordered Phase C rounds for optimal workflow | Claude |

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Current State Analysis](#current-state-analysis)
3. [System Architecture](#system-architecture)
4. [Phase Plans](#phase-plans)
5. [Safety Protocols](#safety-protocols)
6. [Operations Manual](#operations-manual)
7. [Success Criteria](#success-criteria)
8. [Troubleshooting Guide](#troubleshooting-guide)
9. [Appendices](#appendices)

---

## 1. Executive Summary

### Problem Statement

The file system is severely fragmented with critical organizational issues:
- **32,000+ files** scattered across multiple locations without clear structure
- **8 loose configuration files** in /home/kyler root directory
- **62 Desktop items** (42 files + 20 folders totaling 5GB) creating visual clutter
- **31,672 UNSORTED files** (2.8GB) on Desktop with mixed content types
- **~9GB of bloated caches** (.npm, .cache, .nvm) consuming unnecessary space
- **Documentation scattered** across 5+ locations with duplicates (4x claude.md, 4x agents.md)
- **100+ files in Downloads** folder requiring categorization

### Proposed Solution

Deploy a **6-LLM collaborative organization system** using spatial partitioning to eliminate coordination conflicts:

| LLM Agent | Zone | Responsibility | File Count | Size |
|-----------|------|----------------|------------|------|
| **Claude** | Zone 1 | `/home/kyler/*.{md,txt,json}` | 8 files | ~5MB |
| **Codex-1** | Zone 2 | Linux caches | ~1000s | ~9GB |
| **Gemini-1** | Zone 3 | Documentation consolidation | ~20 files | ~50MB |
| **Claude-2** | Zone 6 | Desktop (excl. UNSORTED) | 62 items | ~5GB |
| **Codex-2** | Zone 5 | UNSORTED folder | 31,672 files | 2.8GB |
| **Gemini-2** | Zone 4 | Downloads folder | 100+ files | ~10GB |

### Key Innovation: Zero-Conflict Spatial Partitioning

Each LLM operates in **exclusive, non-overlapping zones**. No two agents ever access the same file path, eliminating race conditions entirely.

### Expected Outcomes

✅ **Home directory**: 8 loose files → 0 (moved to organized docs/ structure)
✅ **Desktop**: 62 items → <10 (clean workspace)
✅ **UNSORTED**: 31,672 files → <100 (categorized and moved to D: drive)
✅ **Caches**: ~9GB → <3GB (6GB recovered)
✅ **Documentation**: 5+ locations → 2 canonical locations with symlinks
✅ **Total space recovery**: 10-15GB

### Timeline

- **Phase A**: Parallel Analysis - 60 minutes (all 6 LLMs in parallel)
- **Phase B**: Collaborative Voting - 30 minutes (6-way voting)
- **Phase C**: Sequential Execution - 4.5 hours (6 rounds, one LLM at a time)
  - Round 1: Claude (15min)
  - Round 2: Codex-1 (30min)
  - Round 3: Gemini-1 (30min)
  - Round 4: Claude-2 (60min)
  - Round 5: Codex-2 (90min)
  - Round 6: Gemini-2 (30min)
- **Phase D**: Verification - 30 minutes (all 6 LLMs cross-verify)
- **Total**: ~6.5 hours active execution

---

## 2. Current State Analysis

### Zone 1: /home/kyler Root (Claude)

**Current State** (as of 2025-10-20):
```
Files: 8
- INDEX.md
- PROJECT_DIRECTORIES_MAP.md
- QUICK_REFERENCE_SUMMARY.txt
- README.md
- README_ANALYSIS.md
- TECHNOLOGY_PROFILE_ANALYSIS.md
- checkpoint.md
- (plus 1 more)
```

**Issues**:
- Documentation files scattered in root instead of organized hierarchy
- No clear categorization (analysis docs vs. project maps vs. checkpoints)

**Target State**:
```
/home/kyler/docs/
├── analysis/
│   ├── README_ANALYSIS.md
│   ├── TECHNOLOGY_PROFILE_ANALYSIS.md
│   └── QUICK_REFERENCE_SUMMARY.txt
├── project-maps/
│   ├── INDEX.md
│   └── PROJECT_DIRECTORIES_MAP.md
├── checkpoints/
│   └── checkpoint.md
└── README.md
```

### Zone 6: Desktop (Claude-2)

**Current State** (as of 2025-10-20):

**Folders** (20+):
```
LARGEST:
- ChaosClub (1.3GB)
- Chat gpt chats (1.2GB)
- Installers (1.1GB)
- 825OneNote (394MB)
- FlashFusion.co (196MB)
- Figma-Context-MCP (193MB)
- Pictures (129MB)
- Docs (123MB)
- prompts (106MB)
- flutter (76MB)

PROJECTS:
- GithubRepos
- INT-Smart-Triage-AI-2.0
- FlashFusion Tools Website
- ContentGeneratorAPP
- ClaudeDesktopMCPS

PERSONAL:
- School
- Work
- Book
- Secrets_files

OTHER:
- Agentic Project Management
- files (1)
- taskade_bundle
- odyssey-learns-main
```

**Files** (42):
```
SHORTCUTS (.lnk): 18+
- Claude.lnk, Claude (1).lnk (duplicate!)
- Cursor.lnk, Docker Desktop.lnk
- Notion.lnk, Taskade.lnk
- Codespaces.lnk, Make.lnk
- Azure portal.lnk, Cloudflare.lnk
- etc.

DOCUMENTS:
- 90percentcompletedPROJEctlist.txt
- AI Development Partnership Guide (2.txt
- AI_Accelerated_App_Development_Playbook_ContextEngine.txt
- EXTRACTION_INSTRUCTIONS.txt.pdf
- FlashFusion_Learn_Bridge_Builder_Genesis.pdf
- FlashFusion_Learn_Complete_Transcript.docx
- 🎯 MISSION Complete FlashFusion Pla.txt
- # 🔍 COMPREHENSIVE SYSTEM SCAN AND.txt

ARCHIVES:
- Browser_Extention.zip
- FlashFusion Tools Website.zip
- ReplitExport-kylerosebrook.tar.gz (41MB)

SKILLS:
- claude-skills-v1.0.0
- flashfusionskillsforclaude.skills
- checkpoint-restore.skill
- self-critique.skill

EXECUTABLES:
- firebase-tools-instant-win.exe (204MB)

MEDIA:
- Digavatar.mp3

CONFIG:
- desktop.ini
- anthropic-secure-api (folder)
```

**Issues**:
- Massive visual clutter (62 items on Desktop)
- Duplicate shortcuts (Claude.lnk vs Claude (1).lnk)
- Large folders consuming space (ChaosClub 1.3GB, Chat gpt chats 1.2GB)
- Mixed content types (projects, docs, installers, shortcuts, personal files)
- No clear organization system
- Secrets_files folder on Desktop (security risk)
- OneDrive sync conflicts potential with so many files

**Target State**:
```
Desktop: <10 items (only active shortcuts + current project folder)

MOVED TO:
- Projects → /mnt/d/Projects/Active/ or /mnt/d/Projects/Archive/
- Installers → /mnt/d/05_Resources/Installers/2025-Desktop/
- Chat history → /mnt/d/06_Knowledge_Base/AI-Training/ChatGPT-History/
- Documentation → /mnt/d/04_Documentation/
- Claude skills → /home/kyler/.claude/skills/
- Secrets → /home/kyler/.secrets-vault/ (encrypted)
- Shortcuts → Organized into folders or Start Menu
```

### Zone 2: Linux Caches (Codex-1)

**Current State**:
```
.cache/     ~4.1GB
.npm/       ~2.8GB (includes 450MB in _cacache/tmp/)
.nvm/       ~2.3GB (multiple Node versions)
Total:      ~9.2GB
```

**Issues**:
- Stale cache entries (>90 days old)
- Multiple Node.js versions in .nvm (only need current + LTS)
- Orphaned npm cache files

**Target State**:
```
.cache/     <1GB (cleaned)
.npm/       <1GB (verified + trimmed)
.nvm/       <1GB (keep v22.19.0 + latest LTS only)
Total:      <3GB
Recovery:   6GB+
```

### Zone 5: UNSORTED Folder (Codex-2)

**Current State** (as of 2025-10-20):
```
Total files: 31,672
Total size:  2.8GB

FILE TYPE DISTRIBUTION:
- JavaScript:  12,333 .js files
- TypeScript:   6,286 .ts files
- Source maps:  5,469 .map files
- CommonJS:     2,089 .cjs files
- TypeScript CJS: 1,984 .cts files
- JSON configs:   873 .json files
- Documentation:  696 .md files
- TypeScript JSX: 445 .tsx files
- ESM modules:    309 .mjs files
- TS ESM:         182 .mts files
- Archives:        87 .zip files
- Images:          62 .png, 49 .jpg
- SQL files:       47 .sql files
- YAML configs:    34 .yml files
```

**Issues**:
- Massive code dump (likely from project exports/clones)
- Potential duplicate files by hash
- 5,469 source maps (likely many orphaned without matching source)
- Mixed project fragments
- No organization structure

**Target State**:
```
/mnt/d/05_Resources/UNSORTED-Recovery-2025-10/
├── projects/              # Reconstructed projects (5-15 detected)
│   ├── react-app-1/
│   ├── nextjs-site-2/
│   └── node-utils-3/
├── components/            # Standalone components
│   ├── buttons/
│   ├── forms/
│   └── layouts/
├── utilities/             # Helper functions
├── assets/               # Images (111), SQL (47)
├── configs/              # JSON (873), YAML (34)
├── documentation/        # 696 .md files
├── source-maps/          # Paired with sources
├── orphaned-maps/        # Maps without source files
└── duplicates/
    ├── keep/
    └── delete-candidates/

ORIGINAL UNSORTED: <100 files remaining (critical unknowns only)
Space savings: 500MB-1GB from deduplication
```

### Zone 3: Documentation Consolidation (Gemini-1)

**Current State** (as of 2025-10-20):

**Documentation Issues**:
- claude.md exists in 4 locations:
  - /mnt/d/00_Homebase/documentation/canonical/CLAUDE.md
  - /home/kyler/projects/flashfusion/packages/shared/CLAUDE.md
  - /home/kyler/clones/claude.md
  - /home/kyler/INT-Smart-Triage-AI-2.0/claude.md
- agents.md exists in 4 locations (similar scatter)
- Multiple versions with slight differences
- No clear "source of truth"

**Issues**:
- Documentation fragmentation across 5+ locations
- Duplicate content wasting space
- Confusion about which version is current
- Hard to maintain consistency

**Target State**:
```
Canonical Locations:
- /mnt/d/00_Homebase/documentation/canonical/CLAUDE.md (single source of truth)
- /mnt/d/00_Homebase/documentation/canonical/AGENTS.md (single source of truth)

Symlinks in projects:
- All project folders link to canonical versions
- Example: ln -s /mnt/d/00_Homebase/documentation/canonical/CLAUDE.md /home/kyler/projects/foo/CLAUDE.md
```

### Zone 4: Downloads Folder (Gemini-2)

**Current State** (as of 2025-10-20):

**Downloads Folder**: `/mnt/c/Users/kyler/Downloads`
- **100+ files** requiring categorization
- Mix of installers, archives, documents, scripts
- Files from Aug-Oct 2025
- No organization structure

**File Types**:
- Installers (.exe): 10+
- Archives (.zip, .tar.gz): 20+
- Documents (.md, .pdf, .docx): 30+
- Scripts (.py): 10+
- Media (images, videos): 20+
- Other: 10+

**Issues**:
- Download folder used as temporary working directory
- Old installers for already-installed apps
- Project archives mixed with temporary files
- Interview materials mixed with technical docs

**Target State**:
```
Downloads: <20 files (only recent/active downloads)

MOVED TO:
- Installers (.exe) → /mnt/d/05_Resources/Installers/2025-Downloads/
- Archives (.zip) → /mnt/d/03_Development/Archives/
- Documents → /mnt/d/04_Documentation/ (by category)
- Scripts (.py) → /home/kyler/scripts/
- Media → Appropriate folders based on content
```

### Protected Zones (No Changes)

```
.ssh/                # SSH keys - DO NOT TOUCH
.aws/                # AWS credentials - DO NOT TOUCH
.azure/              # Azure credentials - DO NOT TOUCH
.claude/             # Claude configs - READ ONLY
.codex/              # Codex configs - READ ONLY
.gemini/             # Gemini configs - READ ONLY
Active git repos/    # Repos with uncommitted changes - PROTECTED
```

---

## 3. System Architecture

### LLM Agent Roles & Capabilities

#### Claude (Me) - Orchestrator & Zone 1 Owner

**Strengths**:
- Complex reasoning and contextual decision-making
- Safety-first approach (won't break critical systems)
- Documentation and structured planning
- Git repository awareness

**Weaknesses**:
- Token budget constraints
- Slower on bulk operations

**Responsibilities**:
- Overall coordination and progress tracking
- Critical decisions (what to delete, merge strategies)
- Security review (protect credentials, secrets)
- Final verification of all moves/deletions
- Documentation structure design
- Git repository safety checks
- **Zone 1**: Organize 8 home files into docs/ structure

#### Claude-2 - Desktop Organization Specialist

**Strengths**:
- Contextual reasoning ("Is ChaosClub active or archive?")
- Safety-first (won't move active projects accidentally)
- Link management (smart handling of .lnk shortcuts)
- Documentation understanding (can read README to understand folders)
- Human-like judgment for mixed content

**Responsibilities**:
- **Zone 6**: Desktop folder/file organization (62 items → <10)
- Project classification (active vs. archive)
- Shortcut cleanup and organization
- Secrets_files secure handling
- OneDrive sync coordination for Desktop changes

#### Codex-1 - Cache Cleanup Specialist

**Strengths**:
- Fast code execution
- Pattern matching and bulk operations
- Metadata extraction from package files
- Dependency tree analysis

**Responsibilities**:
- **Zone 2**: Linux cache cleanup (~9GB → <3GB)
- npm cache verification and trimming
- .nvm Node version management
- Orphaned node_modules detection
- Dependency health checks

#### Codex-2 - UNSORTED Analysis & Organization

**Strengths**:
- Code file detection and categorization
- Duplicate detection via MD5 hashing
- Project structure reconstruction
- Source map pairing
- Fast processing of 30K+ files

**Responsibilities**:
- **Zone 5**: UNSORTED folder processing (31,672 files → <100)
- Duplicate detection and removal
- Project reconstruction from fragments
- Component/utility categorization
- Source map pairing with sources
- File type organization

#### Gemini-1 - Documentation Consolidation Specialist

**Strengths**:
- 2M token context window (can handle large files)
- Content comparison and diff analysis
- Multimodal analysis (can process PDFs for documentation)
- Long-context reasoning for taxonomy design

**Responsibilities**:
- **Zone 3**: Documentation consolidation ONLY
- Find and compare all claude.md and agents.md versions
- Establish canonical versions in /mnt/d/00_Homebase/documentation/canonical/
- Create symlinks in all projects pointing to canonical versions
- Documentation taxonomy design
- **Runs in Round 3** (before Claude-2, so Desktop projects can reference canonical docs)

#### Gemini-2 - Downloads Folder Curator

**Strengths**:
- 2M token context window (can handle many files)
- Multimodal analysis (can process PDFs, images to categorize)
- Creative categorization strategies
- Smart file type detection

**Responsibilities**:
- **Zone 4**: Downloads folder processing ONLY (100+ files)
- Categorize installers, archives, documents, scripts, media
- Move files to appropriate D: drive locations
- Clean up old/redundant downloads
- Media file categorization
- **Runs in Round 6** (last, after all other organization complete)

### Zone Ownership Matrix

| Zone | Owner | Path | Read/Write | Lock Required | OneDrive Sync | Round |
|------|-------|------|------------|---------------|---------------|-------|
| 1 | Claude | `/home/kyler/*.{md,txt,json}` | RW | Yes | No | 1 |
| 2 | Codex-1 | `~/.cache/`, `~/.npm/`, `~/.nvm/` | RW | Yes | No | 2 |
| 3 | Gemini-1 | All `.md` files in subdirs | RW | Yes | No | 3 |
| 4 | Gemini-2 | `/mnt/c/Users/kyler/Downloads/` | RW | Yes | No | 6 |
| 5 | Codex-2 | `.../Desktop/UNSORTED/` | RW | Yes | Pause | 5 |
| 6 | Claude-2 | `.../Desktop/*` (excl. UNSORTED) | RW | Yes | Pause | 4 |
| Protected | None | `.ssh/`, `.aws/`, `.azure/` | RO | No | No | N/A |

**Key**: RO = Read-Only, RW = Read-Write

**Execution Order**: Round 1 → 2 → 3 → 4 → 5 → 6 (sequential, one at a time)

### Conflict Prevention Mechanism

```
┌─────────────────────────────────────────────────┐
│         Spatial Partitioning Strategy           │
└─────────────────────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        ▼               ▼               ▼
   ┌────────┐      ┌────────┐      ┌────────┐
   │ Zone 1 │      │ Zone 2 │      │ Zone 6 │
   │ Claude │      │Codex-1 │      │Claude-2│
   └────────┘      └────────┘      └────────┘
        │               │               │
        └───────────────┼───────────────┘
                        ▼
              No Overlapping Paths
              ─────────────────────
           ✅ Zero Conflict Guarantee
```

**Guarantees**:
1. **Spatial Isolation**: No two LLMs write to same path
2. **Temporal Isolation**: Only ONE LLM writes at a time (lock system)
3. **Logical Isolation**: Each LLM operates on semantically distinct data

### Lock System

**Lock File**: `/tmp/org-lock.json`

```json
{
  "holder": "claude-2",
  "zone": 6,
  "acquired_at": "2025-10-20T10:30:00Z",
  "pid": 12345,
  "operation": "Desktop organization",
  "timeout_at": "2025-10-20T12:00:00Z"
}
```

**Lock Acquisition**:
```bash
# Atomic lock creation (fails if exists)
set -o noclobber
echo '{"holder":"claude-2","zone":6,...}' > /tmp/org-lock.json
```

**Lock Release**:
```bash
rm /tmp/org-lock.json
```

### Communication Protocol

**Shared State File**: `/tmp/org-state.json`

```json
{
  "phase": "C",
  "current_executor": "claude-2",
  "operations_completed": 15,
  "operations_total": 47,
  "errors": 0,
  "warnings": 2,
  "last_checkpoint": "/mnt/d/BACKUPS/.../checkpoint-20251020-103000/"
}
```

**Real-time Log**: `/tmp/org-execution.log`
```
[2025-10-20 10:30:00] CLAUDE: Starting Phase C, Round 1
[2025-10-20 10:30:01] CLAUDE: LOCK acquired for Zone 1
[2025-10-20 10:30:05] CLAUDE: Created /home/kyler/docs/analysis/ ✓
[2025-10-20 10:31:22] CLAUDE: Moved 8 files successfully ✓
[2025-10-20 10:31:30] CLAUDE: LOCK released
```

---

## 4. Phase Plans

### Phase A: Parallel Read-Only Discovery (60 minutes)

**Objective**: All 5 LLMs analyze their zones simultaneously with ZERO file modifications.

**Phase A is 100% safe** - read-only operations cannot corrupt data.

#### Claude's Tasks (Zone 1)

```bash
# Working directory: /home/kyler

# Task 1: Inventory loose files
ls -lah /home/kyler/*.{md,txt,json} 2>/dev/null > /tmp/claude-zone1-files.txt

# Task 2: Identify symlinks
find /home/kyler -maxdepth 1 -type l -ls > /tmp/claude-symlinks.txt

# Task 3: Check git repositories
find /home/kyler -maxdepth 3 -name .git -type d > /tmp/claude-git-repos.txt
for repo in $(cat /tmp/claude-git-repos.txt | sed 's/.git$//'); do
  echo "=== $repo ===" >> /tmp/claude-git-status.txt
  git -C "$repo" status --short >> /tmp/claude-git-status.txt
done

# Task 4: Scan Claude/Codex/Gemini configs
find /home/kyler/.claude /home/kyler/.codex /home/kyler/.gemini -type f 2>/dev/null | \
  head -20 > /tmp/claude-llm-configs.txt

# Task 5: Create protected paths list
cat > /tmp/claude-protected-paths.txt <<EOF
/home/kyler/.ssh/
/home/kyler/.aws/
/home/kyler/.azure/
/home/kyler/.claude/
/home/kyler/.codex/
/home/kyler/.gemini/
EOF

# Output: /tmp/claude-analysis.json
cat > /tmp/claude-analysis.json <<EOF
{
  "llm": "claude",
  "zone": 1,
  "timestamp": "$(date -Iseconds)",
  "files_analyzed": $(ls -1 /home/kyler/*.{md,txt,json} 2>/dev/null | wc -l),
  "symlinks_found": $(cat /tmp/claude-symlinks.txt | wc -l),
  "git_repos": $(cat /tmp/claude-git-repos.txt | wc -l),
  "uncommitted_changes": $(grep -c "^[MADR]" /tmp/claude-git-status.txt || echo 0),
  "recommendations": [
    "Move docs to /home/kyler/docs/ structure",
    "Create analysis/, project-maps/, checkpoints/ subdirs",
    "Verify no symlinks will break after moves"
  ],
  "safety_concerns": []
}
EOF
```

**Expected Output**: `/tmp/claude-analysis.json`

#### Claude-2's Tasks (Zone 6)

```bash
# Working directory: /mnt/c/Users/kyler/OneDrive/Desktop (excluding UNSORTED)

# Task 1: Folder classification
du -sh "/mnt/c/Users/kyler/OneDrive/Desktop"/* 2>/dev/null | \
  grep -v UNSORTED | sort -rh > /tmp/claude2-folder-sizes.txt

# Task 2: File categorization by type
find "/mnt/c/Users/kyler/OneDrive/Desktop" -maxdepth 1 -type f | \
  sed 's/.*\.//' | sort | uniq -c | sort -rn > /tmp/claude2-file-types.txt

# Task 3: Shortcut inventory
find "/mnt/c/Users/kyler/OneDrive/Desktop" -maxdepth 1 -name "*.lnk" | \
  sort > /tmp/claude2-shortcuts.txt

# Task 4: Project detection
for dir in "/mnt/c/Users/kyler/OneDrive/Desktop"/*; do
  if [ -f "$dir/package.json" ] || [ -f "$dir/README.md" ]; then
    echo "$dir" >> /tmp/claude2-projects.txt
  fi
done

# Task 5: Duplicate shortcut detection
find "/mnt/c/Users/kyler/OneDrive/Desktop" -name "*.lnk" | \
  sed 's/ ([0-9]).lnk/.lnk/' | sort | uniq -d > /tmp/claude2-duplicate-shortcuts.txt

# Task 6: Secrets scan
if [ -d "/mnt/c/Users/kyler/OneDrive/Desktop/Secrets_files" ]; then
  echo "WARNING: Secrets_files found on Desktop" > /tmp/claude2-secrets-warning.txt
fi

# Output: /tmp/claude2-analysis.json
cat > /tmp/claude2-analysis.json <<EOF
{
  "llm": "claude-2",
  "zone": 6,
  "timestamp": "$(date -Iseconds)",
  "total_items": $(ls -1 "/mnt/c/Users/kyler/OneDrive/Desktop" | wc -l),
  "folders": $(find "/mnt/c/Users/kyler/OneDrive/Desktop" -maxdepth 1 -type d | wc -l),
  "files": $(find "/mnt/c/Users/kyler/OneDrive/Desktop" -maxdepth 1 -type f | wc -l),
  "shortcuts": $(cat /tmp/claude2-shortcuts.txt | wc -l),
  "projects_detected": $(cat /tmp/claude2-projects.txt | wc -l),
  "duplicate_shortcuts": $(cat /tmp/claude2-duplicate-shortcuts.txt | wc -l),
  "largest_folders": [
    "ChaosClub (1.3GB)",
    "Chat gpt chats (1.2GB)",
    "Installers (1.1GB)"
  ],
  "recommendations": [
    "Move ChaosClub to D:/Projects/ or archive",
    "Archive Chat gpt chats to D:/06_Knowledge_Base/",
    "Move Installers to D:/05_Resources/Installers/",
    "Organize shortcuts by category",
    "Secure Secrets_files to encrypted location"
  ],
  "safety_concerns": [
    "Secrets_files on Desktop (security risk)",
    "OneDrive sync must be paused before operations"
  ]
}
EOF
```

**Expected Output**: `/tmp/claude2-analysis.json`

#### Codex-1's Tasks (Zone 2)

```bash
# Working directory: /home/kyler

# Task 1: Cache size analysis
du -sh ~/.cache ~/.npm ~/.nvm > /tmp/codex1-cache-sizes.txt

# Task 2: npm cache analysis
npm cache verify > /tmp/codex1-npm-verify.txt 2>&1

# Task 3: Find stale cache entries (>90 days)
find ~/.cache -type f -mtime +90 > /tmp/codex1-stale-cache.txt

# Task 4: NVM versions inventory
if [ -d ~/.nvm/versions/node ]; then
  ls -1 ~/.nvm/versions/node/ > /tmp/codex1-nvm-versions.txt
fi

# Task 5: Package.json scan across projects
find ~/projects /mnt/d/Projects -name package.json 2>/dev/null | \
  head -100 > /tmp/codex1-package-jsons.txt

# Task 6: Find orphaned node_modules
find ~/projects -type d -name node_modules 2>/dev/null | \
  while read nm; do
    parent=$(dirname "$nm")
    if [ ! -f "$parent/package.json" ]; then
      echo "$nm (orphaned)" >> /tmp/codex1-orphaned-node-modules.txt
    fi
  done

# Output: /tmp/codex1-analysis.json
CACHE_SIZE=$(du -sb ~/.cache | awk '{print $1}')
NPM_SIZE=$(du -sb ~/.npm | awk '{print $1}')
NVM_SIZE=$(du -sb ~/.nvm | awk '{print $1}')
TOTAL=$((CACHE_SIZE + NPM_SIZE + NVM_SIZE))

cat > /tmp/codex1-analysis.json <<EOF
{
  "llm": "codex-1",
  "zone": 2,
  "timestamp": "$(date -Iseconds)",
  "cache_size_bytes": $CACHE_SIZE,
  "npm_size_bytes": $NPM_SIZE,
  "nvm_size_bytes": $NVM_SIZE,
  "total_size_bytes": $TOTAL,
  "total_size_gb": $(echo "scale=2; $TOTAL / 1073741824" | bc),
  "stale_files_count": $(cat /tmp/codex1-stale-cache.txt | wc -l),
  "nvm_versions": $(cat /tmp/codex1-nvm-versions.txt | wc -l),
  "orphaned_node_modules": $(cat /tmp/codex1-orphaned-node-modules.txt | wc -l),
  "recommendations": [
    "Clean npm cache tmp/ directory (450MB estimated)",
    "Remove stale .cache entries (>90 days old)",
    "Keep only current Node version + latest LTS",
    "Archive orphaned node_modules for review"
  ],
  "expected_recovery_gb": 6
}
EOF
```

**Expected Output**: `/tmp/codex1-analysis.json`

#### Codex-2's Tasks (Zone 5)

```bash
# Working directory: /mnt/c/Users/kyler/OneDrive/Desktop/UNSORTED

# Task 1: File type distribution
find "/mnt/c/Users/kyler/OneDrive/Desktop/UNSORTED" -type f 2>/dev/null | \
  sed 's/.*\.//' | sort | uniq -c | sort -rn > /tmp/codex2-file-types.txt

# Task 2: Total file count and size
UNSORTED_PATH="/mnt/c/Users/kyler/OneDrive/Desktop/UNSORTED"
FILE_COUNT=$(find "$UNSORTED_PATH" -type f 2>/dev/null | wc -l)
TOTAL_SIZE=$(du -sb "$UNSORTED_PATH" 2>/dev/null | awk '{print $1}')

# Task 3: Duplicate detection (sample 1000 largest files)
find "$UNSORTED_PATH" -type f -size +100k 2>/dev/null | \
  head -1000 | \
  xargs md5sum 2>/dev/null | \
  sort | \
  awk '{print $1}' | \
  uniq -d > /tmp/codex2-duplicate-hashes.txt

# Task 4: Package.json detection (potential projects)
find "$UNSORTED_PATH" -name package.json 2>/dev/null > /tmp/codex2-package-jsons.txt

# Task 5: Source map pairing
find "$UNSORTED_PATH" -name "*.map" 2>/dev/null > /tmp/codex2-source-maps.txt
while read map; do
  source="${map%.map}"
  if [ ! -f "$source" ]; then
    echo "$map (orphaned)" >> /tmp/codex2-orphaned-maps.txt
  fi
done < /tmp/codex2-source-maps.txt

# Task 6: Config files inventory
find "$UNSORTED_PATH" -name "*.json" -o -name "*.yml" -o -name "*.yaml" \
  2>/dev/null | wc -l > /tmp/codex2-config-count.txt

# Output: /tmp/codex2-analysis.json
cat > /tmp/codex2-analysis.json <<EOF
{
  "llm": "codex-2",
  "zone": 5,
  "timestamp": "$(date -Iseconds)",
  "total_files": $FILE_COUNT,
  "total_size_bytes": $TOTAL_SIZE,
  "total_size_gb": $(echo "scale=2; $TOTAL_SIZE / 1073741824" | bc),
  "file_type_distribution": {
    "js": $(grep -c "\.js$" /tmp/codex2-file-types.txt || echo 0),
    "ts": $(grep -c "\.ts$" /tmp/codex2-file-types.txt || echo 0),
    "map": $(cat /tmp/codex2-source-maps.txt | wc -l),
    "json": $(grep -c "\.json$" /tmp/codex2-file-types.txt || echo 0),
    "md": $(grep -c "\.md$" /tmp/codex2-file-types.txt || echo 0)
  },
  "potential_projects": $(cat /tmp/codex2-package-jsons.txt | wc -l),
  "duplicate_samples": $(cat /tmp/codex2-duplicate-hashes.txt | wc -l),
  "orphaned_source_maps": $(cat /tmp/codex2-orphaned-maps.txt | wc -l),
  "recommendations": [
    "Reconstruct projects from package.json locations",
    "Deduplicate files (estimated 500MB-1GB savings)",
    "Pair source maps with sources",
    "Move orphaned maps to separate folder",
    "Categorize components, utilities, configs"
  ],
  "expected_recovery_gb": 1
}
EOF
```

**Expected Output**: `/tmp/codex2-analysis.json`

#### Gemini-1's Tasks (Zone 3 - Documentation)

```bash
# Working directory: /home/kyler

# Task 1: Find all claude.md files
find /home/kyler -name claude.md -o -name CLAUDE.md > /tmp/gemini1-claude-md-files.txt

# Task 2: Find all agents.md files
find /home/kyler -name agents.md -o -name AGENTS.md > /tmp/gemini1-agents-md-files.txt

# Task 3: Compare claude.md versions (hash-based)
while read file; do
  md5sum "$file"
done < /tmp/gemini1-claude-md-files.txt > /tmp/gemini1-claude-md-hashes.txt

# Task 4: Compare agents.md versions
while read file; do
  md5sum "$file"
done < /tmp/gemini1-agents-md-files.txt > /tmp/gemini1-agents-md-hashes.txt

# Task 5: Find largest version of each (most complete)
xargs ls -lS < /tmp/gemini1-claude-md-files.txt | head -1 > /tmp/gemini1-best-claude.txt
xargs ls -lS < /tmp/gemini1-agents-md-files.txt | head -1 > /tmp/gemini1-best-agents.txt

# Output: /tmp/gemini1-analysis.json
cat > /tmp/gemini1-analysis.json <<EOF
{
  "llm": "gemini-1",
  "zone": 3,
  "timestamp": "$(date -Iseconds)",
  "claude_md_locations": $(cat /tmp/gemini1-claude-md-files.txt | wc -l),
  "agents_md_locations": $(cat /tmp/gemini1-agents-md-files.txt | wc -l),
  "unique_claude_md_versions": $(awk '{print $1}' /tmp/gemini1-claude-md-hashes.txt | sort -u | wc -l),
  "unique_agents_md_versions": $(awk '{print $1}' /tmp/gemini1-agents-md-hashes.txt | sort -u | wc -l),
  "recommendations": [
    "Establish /mnt/d/00_Homebase/documentation/canonical/CLAUDE.md as canonical",
    "Establish /mnt/d/00_Homebase/documentation/canonical/AGENTS.md as canonical",
    "Create symlinks in all projects pointing to canonical versions",
    "Remove duplicate files after symlink creation"
  ]
}
EOF
```

**Expected Output**: `/tmp/gemini1-analysis.json`

#### Gemini-2's Tasks (Zone 4 - Downloads)

```bash
# Working directory: /mnt/c/Users/kyler/Downloads

# Task 1: Downloads folder inventory
ls -lah "/mnt/c/Users/kyler/Downloads" 2>/dev/null | \
  tail -n +4 > /tmp/gemini2-downloads-inventory.txt

# Task 2: Categorize Downloads by type
find "/mnt/c/Users/kyler/Downloads" -type f 2>/dev/null | \
  sed 's/.*\.//' | sort | uniq -c | sort -rn > /tmp/gemini2-downloads-types.txt

# Task 3: Find installers
find "/mnt/c/Users/kyler/Downloads" -name "*.exe" > /tmp/gemini2-installers.txt

# Task 4: Find archives
find "/mnt/c/Users/kyler/Downloads" -name "*.zip" -o -name "*.tar.gz" > /tmp/gemini2-archives.txt

# Task 5: Find documents
find "/mnt/c/Users/kyler/Downloads" -name "*.pdf" -o -name "*.docx" -o -name "*.md" > /tmp/gemini2-documents.txt

# Task 6: Find scripts
find "/mnt/c/Users/kyler/Downloads" -name "*.py" > /tmp/gemini2-scripts.txt

# Output: /tmp/gemini2-analysis.json
cat > /tmp/gemini2-analysis.json <<EOF
{
  "llm": "gemini-2",
  "zone": 4,
  "timestamp": "$(date -Iseconds)",
  "total_files": $(find "/mnt/c/Users/kyler/Downloads" -type f 2>/dev/null | wc -l),
  "installers": $(cat /tmp/gemini2-installers.txt | wc -l),
  "archives": $(cat /tmp/gemini2-archives.txt | wc -l),
  "documents": $(cat /tmp/gemini2-documents.txt | wc -l),
  "scripts": $(cat /tmp/gemini2-scripts.txt | wc -l),
  "recommendations": [
    "Move old installers (>30 days) to D:/05_Resources/Installers/2025-Downloads/",
    "Extract or archive project archives to D:/03_Development/Archives/",
    "Categorize documents by type and move to D:/04_Documentation/",
    "Move scripts to /home/kyler/scripts/ and make executable",
    "Clean up temporary/redundant files"
  ]
}
EOF
```

**Expected Output**: `/tmp/gemini2-analysis.json`

#### Phase A Completion Criteria

✅ All 6 JSON manifests created in /tmp/:
- `/tmp/claude-analysis.json`
- `/tmp/codex1-analysis.json`
- `/tmp/gemini1-analysis.json`
- `/tmp/claude2-analysis.json`
- `/tmp/codex2-analysis.json`
- `/tmp/gemini2-analysis.json`

✅ No files modified (read-only verification)
✅ Total execution time < 70 minutes
✅ No errors in any analysis scripts

**Proceed to Phase B when**: All 6 LLMs report analysis complete

---

### Phase B: Collaborative Planning & Voting (30 minutes)

**Objective**: Merge analyses, resolve conflicts via voting, create execution plan.

#### Step 1: Data Merge (Claude orchestrates)

```bash
# Merge all JSON manifests
jq -s '.' /tmp/claude-analysis.json \
         /tmp/codex1-analysis.json \
         /tmp/gemini1-analysis.json \
         /tmp/claude2-analysis.json \
         /tmp/codex2-analysis.json \
         /tmp/gemini2-analysis.json \
  > /tmp/merged-analysis.json

# Calculate totals
jq '.[] | .files_analyzed // .total_files // 0' /tmp/merged-analysis.json | \
  awk '{sum+=$1} END {print "Total files to process:", sum}'
```

#### Step 2: Decision Matrix

For each item requiring action, LLMs vote:

**Example: FlashFusion.co folder on Desktop**

```yaml
Item: /mnt/c/Users/kyler/OneDrive/Desktop/FlashFusion.co/ (196MB)

Claude vote:     "Check if duplicate of D:/Projects/FlashFusion-* variants"
Codex-1 vote:    (abstain - not in zone)
Gemini-1 vote:   "Has comprehensive README, appears to be website variant"
Claude-2 vote:   "Contains package.json v2.1.0, last modified Sep 2025 - RECENT!"
Codex-2 vote:    (abstain - not in zone)
Gemini-2 vote:   (abstain - not in zone)

CONSENSUS (3/6): Keep on Desktop if actively developing, else move to D:/Projects/Active/
DECISION:        Claude-2 checks git status, if clean → move to D:/Projects/Active/flashfusion-website/
```

**Voting Rules**:
- **Unanimous (6/6)**: Auto-approve
- **Strong majority (5/6 or 4/6 with zone owner)**: Auto-approve
- **Majority (4/6 or 3/6 with zone owner)**: Auto-approve but flag for review
- **Split (3-3, 2-2-2)**: Requires human decision
- **Zone owner veto**: Zone owner always has final say for their zone

#### Step 3: Execution Plan Generation

```bash
# Create sequential operation list
cat > /tmp/execution-plan.json <<EOF
{
  "operations": [
    {
      "id": 1,
      "phase": "C",
      "round": 1,
      "executor": "claude",
      "zone": 1,
      "type": "move_batch",
      "operations": [
        {"src": "/home/kyler/INDEX.md", "dst": "/home/kyler/docs/project-maps/INDEX.md"},
        {"src": "/home/kyler/PROJECT_DIRECTORIES_MAP.md", "dst": "/home/kyler/docs/project-maps/PROJECT_DIRECTORIES_MAP.md"}
      ],
      "estimated_duration_min": 15,
      "dependencies": [],
      "rollback_available": true
    },
    {
      "id": 2,
      "phase": "C",
      "round": 2,
      "executor": "codex-1",
      "zone": 2,
      "type": "delete_cache",
      "path": "~/.npm/_cacache/tmp/*",
      "estimated_size_mb": 450,
      "estimated_duration_min": 30,
      "dependencies": [1],
      "rollback_available": false
    }
  ]
}
EOF
```

#### Phase B Completion Criteria

✅ Execution plan created with all operations
✅ All conflicts resolved (no split votes remaining)
✅ Dependencies mapped (operations ordered correctly)
✅ Estimated timeline confirmed (<= 4 hours for Phase C)

**Proceed to Phase C when**: Execution plan approved

---

### Phase C: Sequential Execution with Locks (4 hours)

**CRITICAL**: Only ONE LLM executes at a time. Lock system enforces this.

#### Pre-Phase C: Full Backup

```bash
# Create backup root
mkdir -p /mnt/d/BACKUPS/organization-2025-10-20/{pre-execution-full,phase-snapshots,operation-logs,metadata}

# Backup Zone 1 (Claude)
echo "Backing up Zone 1..."
rsync -av --progress /home/kyler/*.{md,txt,json} \
  /mnt/d/BACKUPS/organization-2025-10-20/pre-execution-full/zone1-home-kyler/

# Backup Zone 2 (Codex-1)
echo "Backing up Zone 2 (may take 10-15 min for 9GB)..."
rsync -av --progress ~/.cache/ \
  /mnt/d/BACKUPS/organization-2025-10-20/pre-execution-full/zone2-cache-systems/cache/
rsync -av --progress ~/.npm/ \
  /mnt/d/BACKUPS/organization-2025-10-20/pre-execution-full/zone2-cache-systems/npm/
rsync -av --progress ~/.nvm/ \
  /mnt/d/BACKUPS/organization-2025-10-20/pre-execution-full/zone2-cache-systems/nvm/

# Backup Zone 6 (Claude-2) - Desktop
echo "Backing up Zone 6 (may take 5-10 min for 5GB)..."
rsync -av --progress "/mnt/c/Users/kyler/OneDrive/Desktop/" \
  --exclude UNSORTED \
  /mnt/d/BACKUPS/organization-2025-10-20/pre-execution-full/zone6-desktop/

# Backup Zone 5 (Codex-2) - UNSORTED (may take 10-15 min for 2.8GB)
echo "Backing up Zone 5 (31,672 files)..."
rsync -av --progress "/mnt/c/Users/kyler/OneDrive/Desktop/UNSORTED/" \
  /mnt/d/BACKUPS/organization-2025-10-20/pre-execution-full/zone5-unsorted/

# Backup Zones 3&4 (Gemini) - Documentation + Downloads
echo "Backing up Zones 3&4..."
find /home/kyler -name "*.md" -type f | \
  rsync -av --files-from=- / \
  /mnt/d/BACKUPS/organization-2025-10-20/pre-execution-full/zone3-documentation/

rsync -av --progress "/mnt/c/Users/kyler/Downloads/" \
  /mnt/d/BACKUPS/organization-2025-10-20/pre-execution-full/zone4-downloads/

# Generate checksums
echo "Generating checksums for verification..."
find /mnt/d/BACKUPS/organization-2025-10-20/pre-execution-full/ -type f \
  -exec md5sum {} \; > /mnt/d/BACKUPS/organization-2025-10-20/metadata/checksums/pre-execution.md5

echo "✅ Full backup complete. Verify backup integrity:"
du -sh /mnt/d/BACKUPS/organization-2025-10-20/pre-execution-full/
```

**Verify backup before proceeding**:
```bash
# Check backup size is reasonable (~27GB expected)
BACKUP_SIZE=$(du -sb /mnt/d/BACKUPS/organization-2025-10-20/pre-execution-full/ | awk '{print $1}')
if [ $BACKUP_SIZE -lt 20000000000 ]; then
  echo "❌ Backup seems too small. Verify before proceeding."
  exit 1
fi
echo "✅ Backup size: $(echo "scale=2; $BACKUP_SIZE / 1073741824" | bc) GB"
```

#### Round 1: Claude (15 minutes) - Zone 1

```bash
echo "[$(date -Iseconds)] CLAUDE: Attempting to acquire lock for Zone 1" >> /tmp/org-execution.log

# Acquire lock
set -o noclobber
if echo '{"holder":"claude","zone":1,"acquired_at":"'$(date -Iseconds)'"}' > /tmp/org-lock.json 2>/dev/null; then
  echo "[$(date -Iseconds)] CLAUDE: Lock acquired successfully" >> /tmp/org-execution.log
else
  echo "[$(date -Iseconds)] CLAUDE: Failed to acquire lock (another LLM is working)" >> /tmp/org-execution.log
  exit 1
fi
set +o noclobber

# Create directory structure
mkdir -p /home/kyler/docs/{analysis,project-maps,checkpoints}

# Move files (logged with rollback commands)
mv /home/kyler/INDEX.md /home/kyler/docs/project-maps/ && \
  echo '{"op":"move","src":"/home/kyler/INDEX.md","dst":"/home/kyler/docs/project-maps/INDEX.md","rollback":"mv /home/kyler/docs/project-maps/INDEX.md /home/kyler/"}' >> /tmp/org-operations.jsonl

mv /home/kyler/PROJECT_DIRECTORIES_MAP.md /home/kyler/docs/project-maps/ && \
  echo '{"op":"move","src":"/home/kyler/PROJECT_DIRECTORIES_MAP.md","dst":"/home/kyler/docs/project-maps/PROJECT_DIRECTORIES_MAP.md","rollback":"mv /home/kyler/docs/project-maps/PROJECT_DIRECTORIES_MAP.md /home/kyler/"}' >> /tmp/org-operations.jsonl

mv /home/kyler/QUICK_REFERENCE_SUMMARY.txt /home/kyler/docs/analysis/ && \
  echo '{"op":"move","src":"/home/kyler/QUICK_REFERENCE_SUMMARY.txt","dst":"/home/kyler/docs/analysis/QUICK_REFERENCE_SUMMARY.txt","rollback":"mv /home/kyler/docs/analysis/QUICK_REFERENCE_SUMMARY.txt /home/kyler/"}' >> /tmp/org-operations.jsonl

mv /home/kyler/README_ANALYSIS.md /home/kyler/docs/analysis/ && \
  echo '{"op":"move","src":"/home/kyler/README_ANALYSIS.md","dst":"/home/kyler/docs/analysis/README_ANALYSIS.md","rollback":"mv /home/kyler/docs/analysis/README_ANALYSIS.md /home/kyler/"}' >> /tmp/org-operations.jsonl

mv /home/kyler/TECHNOLOGY_PROFILE_ANALYSIS.md /home/kyler/docs/analysis/ && \
  echo '{"op":"move","src":"/home/kyler/TECHNOLOGY_PROFILE_ANALYSIS.md","dst":"/home/kyler/docs/analysis/TECHNOLOGY_PROFILE_ANALYSIS.md","rollback":"mv /home/kyler/docs/analysis/TECHNOLOGY_PROFILE_ANALYSIS.md /home/kyler/"}' >> /tmp/org-operations.jsonl

mv /home/kyler/checkpoint.md /home/kyler/docs/checkpoints/ && \
  echo '{"op":"move","src":"/home/kyler/checkpoint.md","dst":"/home/kyler/docs/checkpoints/checkpoint.md","rollback":"mv /home/kyler/docs/checkpoints/checkpoint.md /home/kyler/"}' >> /tmp/org-operations.jsonl

mv /home/kyler/README.md /home/kyler/docs/ && \
  echo '{"op":"move","src":"/home/kyler/README.md","dst":"/home/kyler/docs/README.md","rollback":"mv /home/kyler/docs/README.md /home/kyler/"}' >> /tmp/org-operations.jsonl

# Verification
REMAINING=$(ls -1 /home/kyler/*.{md,txt,json} 2>/dev/null | wc -l)
if [ $REMAINING -eq 0 ]; then
  echo "[$(date -Iseconds)] CLAUDE: ✅ Zone 1 complete - all files moved" >> /tmp/org-execution.log
else
  echo "[$(date -Iseconds)] CLAUDE: ⚠️ Warning: $REMAINING files still in home root" >> /tmp/org-execution.log
fi

# Release lock
rm /tmp/org-lock.json
echo "[$(date -Iseconds)] CLAUDE: Lock released" >> /tmp/org-execution.log
```

**Verification**:
```bash
# Verify all files moved
ls -1 /home/kyler/*.{md,txt,json} 2>/dev/null
# Expected: No output (all files moved)

# Verify new structure exists
tree /home/kyler/docs/
```

#### Round 2: Codex-1 (30 minutes) - Zone 2

```bash
echo "[$(date -Iseconds)] CODEX-1: Attempting to acquire lock for Zone 2" >> /tmp/org-execution.log

# Acquire lock
set -o noclobber
echo '{"holder":"codex-1","zone":2,"acquired_at":"'$(date -Iseconds)'"}' > /tmp/org-lock.json
set +o noclobber

# Clean npm cache
echo "[$(date -Iseconds)] CODEX-1: Starting npm cache cleanup" >> /tmp/org-execution.log
rm -rf ~/.npm/_cacache/tmp/* && \
  echo '{"op":"delete","path":"~/.npm/_cacache/tmp/*","size_mb":450,"rollback":"not_available"}' >> /tmp/org-operations.jsonl

# Remove old logs
find ~/.npm/_logs -type f -mtime +30 -delete && \
  echo '{"op":"delete","path":"~/.npm/_logs (>30 days)","rollback":"not_available"}' >> /tmp/org-operations.jsonl

# Clean .cache (stale entries)
find ~/.cache -type f -mtime +90 -delete && \
  echo '{"op":"delete","path":"~/.cache (>90 days)","rollback":"not_available"}' >> /tmp/org-operations.jsonl

# NVM cleanup (keep current + LTS only)
CURRENT_NODE="v22.19.0"
LTS_NODE=$(nvm ls-remote --lts | tail -1 | awk '{print $1}')
cd ~/.nvm/versions/node/
for version in */; do
  if [ "$version" != "$CURRENT_NODE/" ] && [ "$version" != "$LTS_NODE/" ]; then
    echo "[$(date -Iseconds)] CODEX-1: Removing old Node version: $version" >> /tmp/org-execution.log
    rm -rf "$version"
  fi
done

# Verification
echo "[$(date -Iseconds)] CODEX-1: Verifying npm still works..." >> /tmp/org-execution.log
npm --version || echo "❌ npm broken!" >> /tmp/org-execution.log
node --version || echo "❌ node broken!" >> /tmp/org-execution.log

# Calculate recovery
FINAL_SIZE=$(du -sb ~/.cache ~/.npm ~/.nvm | awk '{sum+=$1} END {print sum}')
RECOVERED=$((9000000000 - FINAL_SIZE))
echo "[$(date -Iseconds)] CODEX-1: ✅ Recovered $(echo "scale=2; $RECOVERED / 1073741824" | bc) GB" >> /tmp/org-execution.log

# Release lock
rm /tmp/org-lock.json
echo "[$(date -Iseconds)] CODEX-1: Lock released" >> /tmp/org-execution.log
```

**Verification**:
```bash
# Verify cache size reduced
du -sh ~/.cache ~/.npm ~/.nvm
# Expected: Each <1GB

# Verify tools still work
npm --version && node --version && echo "✅ npm/node OK"
```

#### Round 3: Gemini-1 (30 minutes) - Zone 3

```bash
# Acquire lock
set -o noclobber
echo '{"holder":"gemini-1","zone":3,"acquired_at":"'$(date -Iseconds)'"}' > /tmp/org-lock.json
set +o noclobber

echo "[$(date -Iseconds)] GEMINI-1: Starting documentation consolidation..." >> /tmp/org-execution.log

# Establish canonical claude.md
CANONICAL_CLAUDE="/mnt/d/00_Homebase/documentation/canonical/CLAUDE.md"
mkdir -p "$(dirname \"$CANONICAL_CLAUDE\")"

# Find the most complete version (largest file)
BEST_CLAUDE=$(find /home/kyler -name claude.md -o -name CLAUDE.md 2>/dev/null | xargs ls -lS 2>/dev/null | head -1 | awk '{print $NF}')
cp "$BEST_CLAUDE" "$CANONICAL_CLAUDE"

# Create symlinks in projects
find /home/kyler/projects /home/kyler/INT-Smart-Triage-AI-2.0 -name claude.md -o -name CLAUDE.md 2>/dev/null | \
  while read old_claude; do
    rm "$old_claude"
    ln -s "$CANONICAL_CLAUDE" "$old_claude"
    echo '{"op":"symlink","src":"'"$old_claude"'","dst":"'"$CANONICAL_CLAUDE"'"}' >> /tmp/org-operations.jsonl
  done

# Same for agents.md
CANONICAL_AGENTS="/mnt/d/00_Homebase/documentation/canonical/AGENTS.md"
BEST_AGENTS=$(find /home/kyler -name agents.md -o -name AGENTS.md 2>/dev/null | xargs ls -lS 2>/dev/null | head -1 | awk '{print $NF}')
cp "$BEST_AGENTS" "$CANONICAL_AGENTS"

find /home/kyler/projects /home/kyler/INT-Smart-Triage-AI-2.0 -name agents.md -o -name AGENTS.md 2>/dev/null | \
  while read old_agents; do
    rm "$old_agents"
    ln -s "$CANONICAL_AGENTS" "$old_agents"
    echo '{"op":"symlink","src":"'"$old_agents"'","dst":"'"$CANONICAL_AGENTS"'"}' >> /tmp/org-operations.jsonl
  done

# Consolidate README files
echo "[$(date -Iseconds)] GEMINI-1: Consolidating README files..." >> /tmp/org-execution.log
mkdir -p /home/kyler/docs/project-readmes/

find /home/kyler -maxdepth 2 -name "README*.md" -not -path "*/node_modules/*" | \
  while read readme; do
    PROJECT_NAME=$(basename $(dirname "$readme"))
    cp "$readme" "/home/kyler/docs/project-readmes/${PROJECT_NAME}_README.md"
    echo '{"op":"copy","src":"'"$readme"'","dst":"/home/kyler/docs/project-readmes/"}' >> /tmp/org-operations.jsonl
  done

# Create documentation index
echo "[$(date -Iseconds)] GEMINI-1: Creating documentation index..." >> /tmp/org-execution.log
cat > /home/kyler/docs/DOCUMENTATION_INDEX.md <<'EOF'
# Documentation Index

Generated: $(date -Iseconds)

## Canonical AI Guidelines
- **Claude Guidelines**: `/mnt/d/00_Homebase/documentation/canonical/CLAUDE.md`
- **Agent System**: `/mnt/d/00_Homebase/documentation/canonical/AGENTS.md`

## Project READMEs
$(ls -1 /home/kyler/docs/project-readmes/ | sed 's/^/- /')

## All Documentation Files
$(find /home/kyler/docs -name "*.md" | sort | sed 's/^/- /')
EOF

# Verification
DOC_COUNT=$(find /home/kyler/docs -name "*.md" | wc -l)
echo "[$(date -Iseconds)] GEMINI-1: ✅ Consolidated $DOC_COUNT documentation files" >> /tmp/org-execution.log

# Release lock
rm /tmp/org-lock.json
echo "[$(date -Iseconds)] GEMINI-1: Lock released" >> /tmp/org-execution.log
```

**Verification**:
```bash
# Verify canonical files exist
test -f /mnt/d/00_Homebase/documentation/canonical/CLAUDE.md && echo "✅ Canonical claude.md created"
test -f /mnt/d/00_Homebase/documentation/canonical/AGENTS.md && echo "✅ Canonical agents.md created"

# Verify symlinks
find /home/kyler -name claude.md -type l | wc -l
# Expected: Multiple symlinks pointing to canonical version

# Verify documentation index
cat /home/kyler/docs/DOCUMENTATION_INDEX.md
```

#### Round 4: Claude-2 (60 minutes) - Zone 6

```bash
echo "[$(date -Iseconds)] CLAUDE-2: Pausing OneDrive sync..." >> /tmp/org-execution.log

# Pause OneDrive (CRITICAL for Desktop operations)
powershell.exe -Command "Stop-Process -Name 'OneDrive' -Force" 2>/dev/null || true
sleep 5

# Verify OneDrive stopped
if ! pgrep -x "OneDrive" > /dev/null; then
  echo "[$(date -Iseconds)] CLAUDE-2: ✅ OneDrive sync paused" >> /tmp/org-execution.log
else
  echo "[$(date -Iseconds)] CLAUDE-2: ❌ OneDrive still running! Aborting." >> /tmp/org-execution.log
  exit 1
fi

# Acquire lock
set -o noclobber
echo '{"holder":"claude-2","zone":6,"acquired_at":"'$(date -Iseconds)'"}' > /tmp/org-lock.json
set +o noclobber

DESKTOP="/mnt/c/Users/kyler/OneDrive/Desktop"

# 1. Shortcuts cleanup
echo "[$(date -Iseconds)] CLAUDE-2: Organizing shortcuts..." >> /tmp/org-execution.log
# Remove duplicate shortcuts
rm "$DESKTOP/Claude (1).lnk" 2>/dev/null || true

# 2. Move large folders
echo "[$(date -Iseconds)] CLAUDE-2: Moving large folders..." >> /tmp/org-execution.log

# Chat gpt chats → Knowledge Base
mv "$DESKTOP/Chat gpt chats" /mnt/d/06_Knowledge_Base/AI-Training/ChatGPT-History/ && \
  echo '{"op":"move","src":"Desktop/Chat gpt chats","dst":"D:/06_Knowledge_Base/AI-Training/ChatGPT-History/","size":"1.2GB"}' >> /tmp/org-operations.jsonl

# Installers → Resources
mv "$DESKTOP/Installers" /mnt/d/05_Resources/Installers/2025-Desktop/ && \
  echo '{"op":"move","src":"Desktop/Installers","dst":"D:/05_Resources/Installers/2025-Desktop/","size":"1.1GB"}' >> /tmp/org-operations.jsonl

# 825OneNote → Personal Notes
mv "$DESKTOP/825OneNote" /mnt/d/04_Documentation/Personal_Notes/OneNote/ && \
  echo '{"op":"move","src":"Desktop/825OneNote","dst":"D:/04_Documentation/Personal_Notes/OneNote/","size":"394MB"}' >> /tmp/org-operations.jsonl

# Docs → Documentation
rsync -av "$DESKTOP/Docs/" /mnt/d/04_Documentation/ && rm -rf "$DESKTOP/Docs" && \
  echo '{"op":"move","src":"Desktop/Docs","dst":"D:/04_Documentation/","size":"123MB"}' >> /tmp/org-operations.jsonl

# prompts → Prompts Library
mv "$DESKTOP/prompts" /mnt/d/06_Knowledge_Base/Prompts-Library/ && \
  echo '{"op":"move","src":"Desktop/prompts","dst":"D:/06_Knowledge_Base/Prompts-Library/","size":"106MB"}' >> /tmp/org-operations.jsonl

# 3. Move projects
echo "[$(date -Iseconds)] CLAUDE-2: Moving projects..." >> /tmp/org-execution.log

# FlashFusion.co → Active Projects
mv "$DESKTOP/FlashFusion.co" /mnt/d/Projects/Active/flashfusion-website/ && \
  echo '{"op":"move","src":"Desktop/FlashFusion.co","dst":"D:/Projects/Active/flashfusion-website/"}' >> /tmp/org-operations.jsonl

# Figma-Context-MCP → MCP Servers
mv "$DESKTOP/Figma-Context-MCP" /mnt/d/Projects/Active/mcp-servers/figma-context/ && \
  echo '{"op":"move","src":"Desktop/Figma-Context-MCP","dst":"D:/Projects/Active/mcp-servers/figma-context/"}' >> /tmp/org-operations.jsonl

# 4. Claude skills
echo "[$(date -Iseconds)] CLAUDE-2: Moving Claude skills..." >> /tmp/org-execution.log
mkdir -p /home/kyler/.claude/skills/
mv "$DESKTOP"/claude-skills-v1.0.0 /home/kyler/.claude/skills/ 2>/dev/null || true
mv "$DESKTOP"/*.skill /home/kyler/.claude/skills/ 2>/dev/null || true

# 5. Secrets handling
echo "[$(date -Iseconds)] CLAUDE-2: Securing Secrets_files..." >> /tmp/org-execution.log
mkdir -p /home/kyler/.secrets-vault/
mv "$DESKTOP/Secrets_files" /home/kyler/.secrets-vault/ && \
  chmod 700 /home/kyler/.secrets-vault/ && \
  echo '{"op":"move","src":"Desktop/Secrets_files","dst":"~/.secrets-vault/","security":"encrypted"}' >> /tmp/org-operations.jsonl

# Verification
REMAINING=$(ls -1 "$DESKTOP" | grep -v UNSORTED | wc -l)
echo "[$(date -Iseconds)] CLAUDE-2: Desktop now has $REMAINING items (target: <10)" >> /tmp/org-execution.log

# Resume OneDrive
echo "[$(date -Iseconds)] CLAUDE-2: Resuming OneDrive sync..." >> /tmp/org-execution.log
powershell.exe -Command "Start-Process 'C:\Program Files\Microsoft OneDrive\OneDrive.exe'" 2>/dev/null || true

# Release lock
rm /tmp/org-lock.json
echo "[$(date -Iseconds)] CLAUDE-2: Lock released" >> /tmp/org-execution.log
```

**Verification**:
```bash
# Count remaining Desktop items
ls -1 "/mnt/c/Users/kyler/OneDrive/Desktop" | grep -v UNSORTED | wc -l
# Expected: <10

# Verify OneDrive resumed
pgrep -x OneDrive && echo "✅ OneDrive running" || echo "⚠️ OneDrive not running"
```

#### Round 5: Codex-2 (90 minutes) - Zone 5

```bash
echo "[$(date -Iseconds)] CODEX-2: Pausing OneDrive sync..." >> /tmp/org-execution.log
powershell.exe -Command "Stop-Process -Name 'OneDrive' -Force" 2>/dev/null || true
sleep 5

# Acquire lock
set -o noclobber
echo '{"holder":"codex-2","zone":5,"acquired_at":"'$(date -Iseconds)'"}' > /tmp/org-lock.json
set +o noclobber

UNSORTED="/mnt/c/Users/kyler/OneDrive/Desktop/UNSORTED"
TARGET="/mnt/d/05_Resources/UNSORTED-Recovery-2025-10"

# Create target structure
mkdir -p "$TARGET"/{projects,components,utilities,assets,configs,documentation,source-maps,orphaned-maps,duplicates/{keep,delete-candidates}}

echo "[$(date -Iseconds)] CODEX-2: Processing 31,672 files (estimated 90 min)..." >> /tmp/org-execution.log

# Phase 1: Duplicate detection (20 min)
echo "[$(date -Iseconds)] CODEX-2: Phase 1 - Duplicate detection..." >> /tmp/org-execution.log
find "$UNSORTED" -type f -size +100k | \
  xargs md5sum | \
  sort | \
  awk '{if(seen[$1]++) print $2}' | \
  while read dup; do
    mv "$dup" "$TARGET/duplicates/delete-candidates/"
  done

# Phase 2: Project reconstruction (30 min)
echo "[$(date -Iseconds)] CODEX-2: Phase 2 - Project reconstruction..." >> /tmp/org-execution.log
PROJECT_NUM=1
find "$UNSORTED" -name package.json | while read pkg; do
  PROJECT_DIR=$(dirname "$pkg")
  PROJECT_NAME=$(jq -r '.name // "unknown"' "$pkg")
  mv "$PROJECT_DIR" "$TARGET/projects/project-$PROJECT_NUM-$PROJECT_NAME/"
  ((PROJECT_NUM++))
done

# Phase 3: Categorization (30 min)
echo "[$(date -Iseconds)] CODEX-2: Phase 3 - File categorization..." >> /tmp/org-execution.log

# Components (React/Vue)
find "$UNSORTED" -name "*.tsx" -o -name "*.jsx" -o -name "*.vue" | \
  while read comp; do
    mv "$comp" "$TARGET/components/"
  done

# Utilities
find "$UNSORTED" -path "*/utils/*" -o -path "*/helpers/*" | \
  while read util; do
    mv "$util" "$TARGET/utilities/"
  done

# Assets
find "$UNSORTED" -name "*.png" -o -name "*.jpg" -o -name "*.svg" -o -name "*.sql" | \
  while read asset; do
    mv "$asset" "$TARGET/assets/"
  done

# Configs
find "$UNSORTED" -name "*.json" -o -name "*.yml" -o -name "*.yaml" | \
  while read cfg; do
    mv "$cfg" "$TARGET/configs/"
  done

# Documentation
find "$UNSORTED" -name "*.md" | \
  while read doc; do
    mv "$doc" "$TARGET/documentation/"
  done

# Phase 4: Source map handling (10 min)
echo "[$(date -Iseconds)] CODEX-2: Phase 4 - Source map pairing..." >> /tmp/org-execution.log
find "$UNSORTED" -name "*.map" | while read map; do
  source="${map%.map}"
  if [ -f "$source" ]; then
    mv "$map" "$TARGET/source-maps/"
  else
    mv "$map" "$TARGET/orphaned-maps/"
  fi
done

# Verification
REMAINING=$(find "$UNSORTED" -type f 2>/dev/null | wc -l)
echo "[$(date -Iseconds)] CODEX-2: ✅ UNSORTED now has $REMAINING files (target: <100)" >> /tmp/org-execution.log

# Resume OneDrive
powershell.exe -Command "Start-Process 'C:\Program Files\Microsoft OneDrive\OneDrive.exe'" 2>/dev/null || true

# Release lock
rm /tmp/org-lock.json
echo "[$(date -Iseconds)] CODEX-2: Lock released" >> /tmp/org-execution.log
```

**Verification**:
```bash
# Count remaining UNSORTED files
find "/mnt/c/Users/kyler/OneDrive/Desktop/UNSORTED" -type f | wc -l
# Expected: <100

# Verify organized structure
tree -L 2 /mnt/d/05_Resources/UNSORTED-Recovery-2025-10/
```

#### Round 6: Gemini-2 (30 minutes) - Zone 4

```bash
# Acquire lock
set -o noclobber
echo '{"holder":"gemini-2","zone":4,"acquired_at":"'$(date -Iseconds)'"}' > /tmp/org-lock.json
set +o noclobber

echo "[$(date -Iseconds)] GEMINI-2: Starting Downloads folder processing..." >> /tmp/org-execution.log

DOWNLOADS="/mnt/c/Users/kyler/Downloads"

# Create target directories
mkdir -p /mnt/d/05_Resources/Installers/2025-Downloads/
mkdir -p /mnt/d/03_Development/Archives/
mkdir -p /mnt/d/04_Documentation/Downloads-Archive/
mkdir -p /home/kyler/scripts/downloads-scripts/

# Phase 1: Installers (older than 30 days)
echo "[$(date -Iseconds)] GEMINI-2: Moving installers..." >> /tmp/org-execution.log
find "$DOWNLOADS" -name "*.exe" -mtime +30 2>/dev/null | \
  while read exe; do
    mv "$exe" /mnt/d/05_Resources/Installers/2025-Downloads/
    echo '{"op":"move","src":"'"$exe"'","dst":"/mnt/d/05_Resources/Installers/2025-Downloads/"}' >> /tmp/org-operations.jsonl
  done

# Phase 2: Archives
echo "[$(date -Iseconds)] GEMINI-2: Moving archives..." >> /tmp/org-execution.log
find "$DOWNLOADS" -name "*.zip" -o -name "*.tar.gz" -o -name "*.7z" 2>/dev/null | \
  while read archive; do
    mv "$archive" /mnt/d/03_Development/Archives/
    echo '{"op":"move","src":"'"$archive"'","dst":"/mnt/d/03_Development/Archives/"}' >> /tmp/org-operations.jsonl
  done

# Phase 3: Documentation
echo "[$(date -Iseconds)] GEMINI-2: Moving documentation..." >> /tmp/org-execution.log
find "$DOWNLOADS" -name "*.md" -o -name "*.pdf" -o -name "*.docx" 2>/dev/null | \
  while read doc; do
    mv "$doc" /mnt/d/04_Documentation/Downloads-Archive/
    echo '{"op":"move","src":"'"$doc"'","dst":"/mnt/d/04_Documentation/Downloads-Archive/"}' >> /tmp/org-operations.jsonl
  done

# Phase 4: Scripts
echo "[$(date -Iseconds)] GEMINI-2: Moving scripts..." >> /tmp/org-execution.log
find "$DOWNLOADS" -name "*.py" 2>/dev/null | \
  while read script; do
    SCRIPT_NAME=$(basename "$script")
    mv "$script" /home/kyler/scripts/downloads-scripts/
    chmod +x /home/kyler/scripts/downloads-scripts/"$SCRIPT_NAME"
    echo '{"op":"move","src":"'"$script"'","dst":"/home/kyler/scripts/downloads-scripts/"}' >> /tmp/org-operations.jsonl
  done

# Verification
REMAINING=$(ls -1 "$DOWNLOADS" 2>/dev/null | wc -l)
echo "[$(date -Iseconds)] GEMINI-2: ✅ Downloads now has $REMAINING files (target: <20)" >> /tmp/org-execution.log

# Release lock
rm /tmp/org-lock.json
echo "[$(date -Iseconds)] GEMINI-2: Lock released" >> /tmp/org-execution.log
```

**Verification**:
```bash
# Count remaining Downloads files
ls -1 "/mnt/c/Users/kyler/Downloads" | wc -l
# Expected: <20

# Verify organized locations
ls -lh /mnt/d/05_Resources/Installers/2025-Downloads/
ls -lh /mnt/d/03_Development/Archives/
ls -lh /home/kyler/scripts/downloads-scripts/
```

#### Phase C Completion Criteria

✅ All 6 rounds executed successfully (sequential, not parallel)
✅ Each round verified before proceeding to next
✅ All operations logged in /tmp/org-operations.jsonl
✅ No errors in execution log
✅ Total execution time < 4.5 hours

**Proceed to Phase D when**: All zones report completion

---

### Phase D: Cross-Verification (30 minutes)

**Objective**: Each LLM verifies the others' work.

#### Verification Matrix

| Verifier | Checks | Commands |
|----------|--------|----------|
| **Claude** | Symlinks valid? Git repos healthy? Configs intact? | `find ~ -xtype l`, `git status` in repos |
| **Codex-1** | Projects still build? Dependencies resolved? Scripts executable? | `npm install --dry-run`, `python --version` |
| **Gemini-1** | Canonical docs exist? Symlinks valid? Index created? | `test -f /mnt/d/00_Homebase/documentation/canonical/CLAUDE.md`, `find ~ -name 'CLAUDE.md' -type l` |
| **Claude-2** | Desktop clean? OneDrive syncing? Shortcuts work? | `ls Desktop`, `pgrep OneDrive` |
| **Codex-2** | UNSORTED processed? Files categorized? No orphans? | `find UNSORTED -type f \| wc -l` |
| **Gemini-2** | Downloads clean? Archives moved? Scripts organized? | `ls -1 ~/Downloads \| wc -l` |

#### Health Checks

```bash
# Claude runs:
echo "=== Claude Health Checks ===" >> /tmp/org-health-checks.log

# Check for broken symlinks
BROKEN=$(find /home/kyler -xtype l 2>/dev/null | wc -l)
echo "Broken symlinks: $BROKEN (expected: 0)" >> /tmp/org-health-checks.log

# Check git repos
find /home/kyler -name .git -type d | while read repo; do
  repo_dir=$(dirname "$repo")
  status=$(git -C "$repo_dir" status --short)
  if [ -n "$status" ]; then
    echo "Git repo has uncommitted changes: $repo_dir" >> /tmp/org-health-checks.log
  fi
done

# Check SSH/AWS/Azure configs intact
for cfg in ~/.ssh ~/.aws ~/.azure; do
  if [ -d "$cfg" ]; then
    echo "✅ $cfg intact" >> /tmp/org-health-checks.log
  else
    echo "❌ $cfg MISSING!" >> /tmp/org-health-checks.log
  fi
done

# Codex-1 runs:
echo "=== Codex-1 Health Checks ===" >> /tmp/org-health-checks.log
npm --version && echo "✅ npm OK" >> /tmp/org-health-checks.log || echo "❌ npm BROKEN" >> /tmp/org-health-checks.log
node --version && echo "✅ node OK" >> /tmp/org-health-checks.log || echo "❌ node BROKEN" >> /tmp/org-health-checks.log
python3 --version && echo "✅ python OK" >> /tmp/org-health-checks.log || echo "❌ python BROKEN" >> /tmp/org-health-checks.log

# Claude-2 runs:
echo "=== Claude-2 Health Checks ===" >> /tmp/org-health-checks.log
DESKTOP_COUNT=$(ls -1 "/mnt/c/Users/kyler/OneDrive/Desktop" | grep -v UNSORTED | wc -l)
echo "Desktop items: $DESKTOP_COUNT (target: <10)" >> /tmp/org-health-checks.log
pgrep OneDrive && echo "✅ OneDrive syncing" >> /tmp/org-health-checks.log || echo "⚠️ OneDrive not running" >> /tmp/org-health-checks.log

# Codex-2 runs:
echo "=== Codex-2 Health Checks ===" >> /tmp/org-health-checks.log
UNSORTED_COUNT=$(find "/mnt/c/Users/kyler/OneDrive/Desktop/UNSORTED" -type f 2>/dev/null | wc -l)
echo "UNSORTED files: $UNSORTED_COUNT (target: <100)" >> /tmp/org-health-checks.log

# Gemini runs:
echo "=== Gemini Health Checks ===" >> /tmp/org-health-checks.log
DOWNLOADS_COUNT=$(ls -1 "/mnt/c/Users/kyler/Downloads" | wc -l)
echo "Downloads files: $DOWNLOADS_COUNT (target: <20)" >> /tmp/org-health-checks.log

# Check canonical docs exist
if [ -f /mnt/d/00_Homebase/documentation/canonical/CLAUDE.md ] && [ -f /mnt/d/00_Homebase/documentation/canonical/AGENTS.md ]; then
  echo "✅ Canonical docs exist" >> /tmp/org-health-checks.log
else
  echo "❌ Canonical docs MISSING" >> /tmp/org-health-checks.log
fi
```

#### Final Metrics Collection

```bash
# Generate final report
cat > /tmp/org-final-report.txt <<EOF
==========================================================
   MULTI-LLM ORGANIZATION - FINAL REPORT
==========================================================
Date: $(date)

BEFORE → AFTER:
─────────────────────────────────────────────────────────
Zone 1 (Claude):
  Home files:           8 → $(ls -1 /home/kyler/*.{md,txt,json} 2>/dev/null | wc -l)

Zone 6 (Claude-2):
  Desktop items:        62 → $(ls -1 "/mnt/c/Users/kyler/OneDrive/Desktop" | grep -v UNSORTED | wc -l)

Zone 2 (Codex-1):
  Cache size:           9GB → $(du -sh ~/.cache ~/.npm ~/.nvm | awk '{sum+=$1} END {print sum}')

Zone 5 (Codex-2):
  UNSORTED files:       31,672 → $(find "/mnt/c/Users/kyler/OneDrive/Desktop/UNSORTED" -type f 2>/dev/null | wc -l)

Zone 4 (Gemini):
  Downloads files:      100+ → $(ls -1 "/mnt/c/Users/kyler/Downloads" | wc -l)

SPACE RECOVERY:
─────────────────────────────────────────────────────────
Total recovered:      $(df -h /home/kyler | tail -1 | awk '{print $3}') (estimated 10-15GB)

OPERATIONS:
─────────────────────────────────────────────────────────
Total operations:     $(cat /tmp/org-operations.jsonl | wc -l)
Errors:               $(grep -c "ERROR" /tmp/org-execution.log || echo 0)
Warnings:             $(grep -c "⚠️" /tmp/org-execution.log || echo 0)

HEALTH CHECKS:
─────────────────────────────────────────────────────────
$(cat /tmp/org-health-checks.log)

==========================================================
EOF

cat /tmp/org-final-report.txt
```

#### Phase D Completion Criteria

✅ All health checks pass
✅ Success metrics achieved (see Section 7)
✅ No broken symlinks
✅ All tools still functional (npm, node, python, git)
✅ Final report generated

---

## 5. Safety Protocols

### Backup Strategy

**Location**: `/mnt/d/BACKUPS/organization-2025-10-20/`

**Structure**:
```
/mnt/d/BACKUPS/organization-2025-10-20/
├── pre-execution-full/        # Complete snapshot before any changes (~27GB)
│   ├── zone1-home-kyler/
│   ├── zone2-cache-systems/
│   ├── zone3-documentation/
│   ├── zone4-downloads/
│   ├── zone5-unsorted/
│   └── zone6-desktop/
├── phase-snapshots/           # Incremental after each phase
│   ├── after-phase-A/
│   ├── after-phase-C-round-1/
│   ├── after-phase-C-round-2/
│   ├── after-phase-C-round-3/
│   ├── after-phase-C-round-4/
│   └── after-phase-C-round-5/
├── operation-logs/
│   ├── claude.jsonl
│   ├── claude-2.jsonl
│   ├── codex-1.jsonl
│   ├── codex-2.jsonl
│   └── gemini.jsonl
└── metadata/
    ├── checksums/             # MD5 hashes for integrity verification
    └── rollback-scripts/      # Auto-generated rollback commands
```

### OneDrive Sync Management

**CRITICAL**: Desktop and UNSORTED are OneDrive-synced folders. Modifications during sync can cause conflicts.

**Suspend OneDrive**:
```bash
# Stop OneDrive process
powershell.exe -Command "Stop-Process -Name 'OneDrive' -Force"

# Verify stopped
pgrep OneDrive || echo "✅ OneDrive stopped"
```

**Resume OneDrive**:
```bash
# Start OneDrive
powershell.exe -Command "Start-Process 'C:\Program Files\Microsoft OneDrive\OneDrive.exe'"

# Verify started
sleep 10 && pgrep OneDrive && echo "✅ OneDrive running"
```

**When to pause**:
- Before Claude-2 operations (Desktop)
- Before Codex-2 operations (UNSORTED)
- After operations complete, resume immediately

### Rollback Procedures

#### Per-Operation Rollback

Every operation logged in `/tmp/org-operations.jsonl` includes rollback command:

```json
{"op":"move","src":"/home/kyler/INDEX.md","dst":"/home/kyler/docs/project-maps/INDEX.md","rollback":"mv /home/kyler/docs/project-maps/INDEX.md /home/kyler/"}
```

**Rollback last N operations**:
```bash
#!/bin/bash
# rollback-last.sh <N>

tail -$1 /tmp/org-operations.jsonl | \
  jq -r '.rollback' | \
  tac | \
  while read cmd; do
    if [ "$cmd" != "not_available" ]; then
      echo "Rolling back: $cmd"
      eval "$cmd"
    fi
  done
```

#### Phase-Level Rollback

```bash
# Restore from phase snapshot
rsync -av --delete \
  /mnt/d/BACKUPS/organization-2025-10-20/phase-snapshots/after-phase-C-round-2/ \
  /
```

#### Full Rollback (Emergency)

```bash
#!/bin/bash
# emergency-rollback.sh

echo "⚠️  EMERGENCY ROLLBACK - Restoring from pre-execution backup"

# Stop all operations
rm /tmp/org-lock.json 2>/dev/null

# Pause OneDrive
powershell.exe -Command "Stop-Process -Name 'OneDrive' -Force" 2>/dev/null

# Restore all zones
rsync -av --delete /mnt/d/BACKUPS/organization-2025-10-20/pre-execution-full/zone1-home-kyler/ /home/kyler/
rsync -av --delete /mnt/d/BACKUPS/organization-2025-10-20/pre-execution-full/zone2-cache-systems/ /home/kyler/
rsync -av --delete /mnt/d/BACKUPS/organization-2025-10-20/pre-execution-full/zone6-desktop/ "/mnt/c/Users/kyler/OneDrive/Desktop/"
rsync -av --delete /mnt/d/BACKUPS/organization-2025-10-20/pre-execution-full/zone5-unsorted/ "/mnt/c/Users/kyler/OneDrive/Desktop/UNSORTED/"

# Resume OneDrive
powershell.exe -Command "Start-Process 'C:\Program Files\Microsoft OneDrive\OneDrive.exe'" 2>/dev/null

echo "✅ Full rollback complete. Verify with: diff -r original backup"
```

### Secrets & Sensitive Data Handling

**Protected Paths** (never automate):
```
/home/kyler/.ssh/           # SSH keys
/home/kyler/.aws/           # AWS credentials
/home/kyler/.azure/         # Azure credentials
/home/kyler/.secrets-vault/ # User secrets
```

**Secrets_files folder**:
- **Current location**: Desktop (SECURITY RISK)
- **Target location**: /home/kyler/.secrets-vault/ (encrypted, chmod 700)
- **Handling**: Manual review required before move

**No automated operations on**:
- Files containing "password", "secret", "credential", "token" in path
- .env files
- Files in .ssh/, .aws/, .azure/

---

## 6. Operations Manual

### Pre-Flight Checklist

Before starting Phase A, verify:

- [ ] **Disk space**: D: drive has >30GB free for backups
  ```bash
  df -h /mnt/d | tail -1 | awk '{print $4}'
  ```
- [ ] **No active processes**: No npm installs, builds, or git operations running
  ```bash
  pgrep npm && echo "⚠️ npm running" || echo "✅ npm idle"
  ```
- [ ] **Git repos clean**: No uncommitted changes in important repos
  ```bash
  find ~/projects -name .git -type d | while read repo; do
    git -C "$(dirname $repo)" status --short
  done
  ```
- [ ] **OneDrive synced**: All pending syncs complete before starting
  ```bash
  # Check OneDrive status (no pending uploads)
  ```
- [ ] **Backups ready**: Backup directory created and writable
  ```bash
  mkdir -p /mnt/d/BACKUPS/organization-2025-10-20
  touch /mnt/d/BACKUPS/organization-2025-10-20/test && rm /mnt/d/BACKUPS/organization-2025-10-20/test
  ```
- [ ] **Tmp directory clean**: /tmp/ has space for logs
  ```bash
  df -h /tmp | tail -1 | awk '{print $4}'
  ```
- [ ] **All 5 LLMs available**: Claude, Claude-2, Codex-1, Codex-2, Gemini ready
- [ ] **This document reviewed**: All team members read the plan
- [ ] **User available**: User can respond to questions during execution

### Execution Order

```
┌─────────────────────────────────────────────────────────┐
│                  EXECUTION SEQUENCE                     │
└─────────────────────────────────────────────────────────┘

1. PRE-FLIGHT CHECKS (10 min)
   └─> Verify checklist items above

2. FULL BACKUP (30-45 min)
   └─> rsync all zones to D:/BACKUPS/

3. PHASE A: Analysis (60 min)
   ├─> Claude: Zone 1 analysis
   ├─> Claude-2: Zone 6 analysis
   ├─> Codex-1: Zone 2 analysis
   ├─> Codex-2: Zone 5 analysis
   └─> Gemini: Zones 3&4 analysis
   └─> ALL PARALLEL

4. PHASE B: Planning (30 min)
   ├─> Merge analyses
   ├─> Vote on conflicts
   └─> Generate execution plan

5. PHASE C: Execution (4 hrs)
   ├─> Round 1: Claude (15 min)
   ├─> Round 2: Codex-1 (30 min)
   ├─> Round 3: Claude-2 (60 min)
   ├─> Round 4: Codex-2 (90 min)
   └─> Round 5: Gemini (60 min)
   └─> SEQUENTIAL (one at a time)

6. PHASE D: Verification (30 min)
   ├─> All LLMs run health checks
   ├─> Metrics collected
   └─> Final report generated

7. POST-EXECUTION (15 min)
   ├─> Review final report
   ├─> Verify success criteria
   └─> Archive backups
```

### Monitoring Progress

**Real-time log**:
```bash
# Watch execution log
tail -f /tmp/org-execution.log
```

**Check current phase**:
```bash
# View state
cat /tmp/org-state.json | jq '.'
```

**Check lock status**:
```bash
# See who's working
cat /tmp/org-lock.json 2>/dev/null || echo "No lock (idle or between rounds)"
```

**Operations count**:
```bash
# Count completed operations
wc -l /tmp/org-operations.jsonl
```

### Pause/Resume Procedures

**To pause** (emergency):
```bash
# Wait for current LLM to finish (check lock)
cat /tmp/org-lock.json

# Once lock released, do NOT start next round
# Create stop signal
touch /tmp/org-stop-signal

# Current state saved in /tmp/org-state.json
```

**To resume**:
```bash
# Remove stop signal
rm /tmp/org-stop-signal

# Check state
cat /tmp/org-state.json

# Resume from next round in Phase C
```

---

## 7. Success Criteria

### Metrics Table

| Metric | Baseline (Before) | Target (After) | Verification Command | Priority |
|--------|-------------------|----------------|---------------------|----------|
| **Home files** | 8 | 0 | `ls -1 /home/kyler/*.{md,txt,json} 2>/dev/null \| wc -l` | High |
| **Desktop items** | 62 | <10 | `ls -1 "/mnt/c/.../Desktop" \| grep -v UNSORTED \| wc -l` | High |
| **Desktop size** | ~5GB | <500MB | `du -sh "/mnt/c/.../Desktop" --exclude UNSORTED` | Medium |
| **UNSORTED files** | 31,672 | <100 | `find ".../UNSORTED" -type f \| wc -l` | High |
| **UNSORTED size** | 2.8GB | <100MB | `du -sh ".../UNSORTED"` | Medium |
| **Cache size** | ~9GB | <3GB | `du -sh ~/.{cache,npm,nvm}` | High |
| **Downloads files** | 100+ | <20 | `ls -1 "/mnt/c/.../Downloads" \| wc -l` | Medium |
| **Doc locations** | 5+ (scattered) | 2 (canonical) | `find ~ -name claude.md` | Low |
| **Broken symlinks** | Unknown | 0 | `find ~ -xtype l \| wc -l` | High |
| **Total space recovered** | 0 | 10-15GB | `df -h /home/kyler` | Medium |

### Acceptance Tests

#### Test 1: Home Directory Clean
```bash
# No loose config/doc files in root
test $(ls -1 /home/kyler/*.{md,txt,json} 2>/dev/null | wc -l) -eq 0 && echo "✅ PASS" || echo "❌ FAIL"
```

#### Test 2: Desktop Organized
```bash
# Desktop has <10 items
test $(ls -1 "/mnt/c/Users/kyler/OneDrive/Desktop" | grep -v UNSORTED | wc -l) -lt 10 && echo "✅ PASS" || echo "❌ FAIL"
```

#### Test 3: UNSORTED Processed
```bash
# UNSORTED has <100 files
test $(find "/mnt/c/Users/kyler/OneDrive/Desktop/UNSORTED" -type f 2>/dev/null | wc -l) -lt 100 && echo "✅ PASS" || echo "❌ FAIL"
```

#### Test 4: Cache Cleaned
```bash
# Total cache size <3GB
CACHE_SIZE=$(du -sb ~/.cache ~/.npm ~/.nvm | awk '{sum+=$1} END {print sum}')
test $CACHE_SIZE -lt 3000000000 && echo "✅ PASS ($(echo "scale=2; $CACHE_SIZE / 1073741824" | bc) GB)" || echo "❌ FAIL"
```

#### Test 5: No Data Loss
```bash
# All files accounted for (before count = after count + archived + deleted)
# Manual verification required
```

#### Test 6: Tools Still Work
```bash
# npm, node, python, git all functional
npm --version && node --version && python3 --version && git --version && echo "✅ PASS" || echo "❌ FAIL"
```

#### Test 7: No Broken Symlinks
```bash
# Zero broken symlinks
test $(find /home/kyler -xtype l 2>/dev/null | wc -l) -eq 0 && echo "✅ PASS" || echo "❌ FAIL"
```

#### Test 8: Canonical Docs Exist
```bash
# claude.md and agents.md in canonical location
test -f /mnt/d/00_Homebase/documentation/canonical/CLAUDE.md && \
test -f /mnt/d/00_Homebase/documentation/canonical/AGENTS.md && \
echo "✅ PASS" || echo "❌ FAIL"
```

### Performance Validation

```bash
# Measure performance before/after

# BEFORE:
time ls -R /home/kyler > /dev/null  # Baseline

# AFTER:
time ls -R /home/kyler > /dev/null  # Should be similar or faster

# Expected: No significant performance degradation
```

---

## 8. Troubleshooting Guide

### Common Issues & Solutions

#### Issue 1: OneDrive Sync Conflicts

**Symptoms**:
- Files appear duplicated with "conflicted copy" in filename
- OneDrive shows sync errors

**Cause**: OneDrive resumed sync during file operations

**Recovery**:
1. Stop OneDrive immediately:
   ```bash
   powershell.exe -Command "Stop-Process -Name 'OneDrive' -Force"
   ```
2. Identify conflicted files:
   ```bash
   find "/mnt/c/Users/kyler/OneDrive/Desktop" -name "*conflicted copy*"
   ```
3. Manually resolve conflicts (keep newest/largest version)
4. Resume OneDrive after conflicts resolved

**Prevention**: Verify OneDrive stopped before Desktop/UNSORTED operations

---

#### Issue 2: Lock Timeout / Deadlock

**Symptoms**:
- LLM cannot acquire lock for >10 minutes
- /tmp/org-lock.json exists but no LLM is working

**Cause**: Previous LLM crashed without releasing lock

**Recovery**:
1. Check lock file:
   ```bash
   cat /tmp/org-lock.json
   ```
2. Verify process still running:
   ```bash
   ps aux | grep <pid_from_lock>
   ```
3. If process dead, force release:
   ```bash
   rm /tmp/org-lock.json
   echo "Lock forcibly released at $(date)" >> /tmp/org-execution.log
   ```
4. Resume from last successful round

**Prevention**: Implement lock timeout (auto-release after 2 hours)

---

#### Issue 3: Disk Space Exhausted

**Symptoms**:
- "No space left on device" errors
- Backup or operations fail mid-process

**Cause**: D: drive filled during backup or operations

**Recovery**:
1. Check D: drive space:
   ```bash
   df -h /mnt/d
   ```
2. If full, delete oldest backups:
   ```bash
   rm -rf /mnt/d/BACKUPS/organization-2025-10-19  # Previous backup
   ```
3. If still full, clean large temporary files:
   ```bash
   du -sh /mnt/d/* | sort -rh | head -10
   ```
4. Resume operations after space freed

**Prevention**: Verify >30GB free on D: before starting

---

#### Issue 4: npm/node Broken After Cache Cleanup

**Symptoms**:
- `npm --version` fails
- `command not found: npm`

**Cause**: Codex-1 deleted critical npm files

**Recovery**:
1. Restore from backup:
   ```bash
   rsync -av /mnt/d/BACKUPS/.../zone2-cache-systems/npm/ ~/.npm/
   ```
2. Verify npm works:
   ```bash
   npm --version
   ```
3. If still broken, reinstall Node:
   ```bash
   nvm install 22.19.0
   nvm use 22.19.0
   ```

**Prevention**: Test `npm --version` in verification step before proceeding

---

#### Issue 5: Git Repository Corruption

**Symptoms**:
- `git status` shows errors
- "fatal: not a git repository"

**Cause**: .git folder accidentally moved/deleted

**Recovery**:
1. Check if .git exists:
   ```bash
   ls -la /path/to/project/.git
   ```
2. If missing, restore from backup:
   ```bash
   rsync -av /mnt/d/BACKUPS/.../pre-execution-full/ /
   ```
3. Verify git works:
   ```bash
   cd /path/to/project && git status
   ```

**Prevention**: Protected paths should NEVER be touched

---

#### Issue 6: Secrets_files Exposed

**Symptoms**:
- Secrets_files visible in unencrypted location
- Permissions too permissive

**Cause**: Improper handling during Claude-2's operations

**Recovery**:
1. Immediately secure:
   ```bash
   chmod 700 /home/kyler/.secrets-vault/
   chmod 600 /home/kyler/.secrets-vault/*
   ```
2. Verify no copies left on Desktop:
   ```bash
   find "/mnt/c/Users/kyler/OneDrive/Desktop" -name "*ecret*" -o -name "*assword*"
   ```
3. Consider rotating credentials if exposure time was significant

**Prevention**: Manual review of Secrets_files before automated moves

---

#### Issue 7: UNSORTED Processing Incomplete

**Symptoms**:
- UNSORTED still has >100 files after Codex-2
- Categorization failed

**Cause**: Script errors or timeouts during processing

**Recovery**:
1. Check Codex-2 logs:
   ```bash
   grep "CODEX-2" /tmp/org-execution.log | tail -50
   ```
2. Identify which phase failed
3. Manually complete categorization or re-run phase

**Prevention**: Process UNSORTED in batches of 5,000 files with checkpoints

---

### Emergency Contacts

**If this plan fails catastrophically**:

1. **Stop all operations**: `rm /tmp/org-lock.json && touch /tmp/org-stop-signal`
2. **Run emergency rollback**: `./emergency-rollback.sh` (see Section 5)
3. **Verify system intact**: Run all health checks (Section 4, Phase D)
4. **Contact**: User (Kyler Rosebrook) for decision on how to proceed

**Do NOT proceed** if:
- Multiple health checks fail
- Critical data appears lost
- System tools (npm, git, python) are broken
- OneDrive conflicts cannot be resolved

---

## 9. Appendices

### Appendix A: Complete File Inventories

#### Zone 1 Inventory (Pre-Execution)
```
/home/kyler/
├── INDEX.md
├── PROJECT_DIRECTORIES_MAP.md
├── QUICK_REFERENCE_SUMMARY.txt
├── README.md
├── README_ANALYSIS.md
├── TECHNOLOGY_PROFILE_ANALYSIS.md
├── checkpoint.md
└── (1 more .json or .md file)
```

#### Zone 6 Inventory (Pre-Execution)
```
Desktop Folders (20):
├── ChaosClub (1.3GB)
├── Chat gpt chats (1.2GB)
├── Installers (1.1GB)
├── 825OneNote (394MB)
├── FlashFusion.co (196MB)
├── Figma-Context-MCP (193MB)
├── Pictures (129MB)
├── Docs (123MB)
├── prompts (106MB)
├── flutter (76MB)
├── GithubRepos
├── INT-Smart-Triage-AI-2.0
├── FlashFusion Tools Website
├── ContentGeneratorAPP
├── ClaudeDesktopMCPS
├── School
├── Work
├── Book
├── Secrets_files
└── (More folders...)

Desktop Files (42):
├── Shortcuts (.lnk): 18+
├── Documents (.txt, .pdf, .docx): 10+
├── Archives (.zip, .tar.gz): 5+
├── Skills (claude-skills-v1.0.0, *.skill): 4
├── Executables (.exe): 2
├── Media (.mp3): 1
└── Config (desktop.ini): 1
```

#### Zone 5 Inventory (Pre-Execution)
```
UNSORTED/ (31,672 files, 2.8GB):
├── JavaScript:         12,333 files
├── TypeScript:          6,286 files
├── Source maps:         5,469 files
├── CommonJS:            2,089 files
├── TypeScript CJS:      1,984 files
├── JSON configs:          873 files
├── Markdown:              696 files
├── TypeScript JSX:        445 files
├── ESM modules:           309 files
├── TypeScript ESM:        182 files
├── Archives:               87 files
├── PNG images:             62 files
├── JPEG images:            49 files
├── SQL files:              47 files
└── YAML configs:           34 files
```

### Appendix B: Command Reference

#### Backup Commands
```bash
# Full backup
rsync -av --progress <source> <destination>

# Incremental backup
rsync -av --progress --link-dest=<previous-backup> <source> <destination>

# Verify backup
diff -r <source> <destination>

# Checksum generation
find <dir> -type f -exec md5sum {} \; > checksums.md5

# Checksum verification
md5sum -c checksums.md5
```

#### Lock Management
```bash
# Acquire lock (atomic)
set -o noclobber
echo '{"holder":"llm-name","zone":N}' > /tmp/org-lock.json
set +o noclobber

# Release lock
rm /tmp/org-lock.json

# Check lock
cat /tmp/org-lock.json

# Force release
rm -f /tmp/org-lock.json
```

#### OneDrive Control
```bash
# Stop OneDrive
powershell.exe -Command "Stop-Process -Name 'OneDrive' -Force"

# Start OneDrive
powershell.exe -Command "Start-Process 'C:\Program Files\Microsoft OneDrive\OneDrive.exe'"

# Check OneDrive status
pgrep OneDrive
```

#### File Operations
```bash
# Move with logging
mv <src> <dst> && echo '{"op":"move","src":"<src>","dst":"<dst>"}' >> /tmp/org-operations.jsonl

# Delete with logging
rm <file> && echo '{"op":"delete","path":"<file>"}' >> /tmp/org-operations.jsonl

# Create symlink
ln -s <target> <link>

# Find broken symlinks
find <dir> -xtype l
```

### Appendix C: Glossary

- **LLM**: Large Language Model (Claude, Codex, Gemini)
- **Zone**: Exclusive directory tree assigned to one LLM
- **Spatial Partitioning**: Strategy where each LLM operates on non-overlapping file paths
- **Lock**: File-based mutex preventing concurrent writes
- **Rollback**: Reversing operations to restore previous state
- **OneDrive Sync**: Cloud synchronization service that must be paused during operations
- **Canonical**: Single authoritative version (e.g., canonical claude.md)
- **Orphaned**: Files without their expected parent/sibling (e.g., .map without .js)
- **Phase**: Major stage in execution (A=Analysis, B=Voting, C=Execution, D=Verification)
- **Round**: Sub-stage within Phase C where one LLM executes
- **Checkpoint**: Snapshot taken at phase boundaries for rollback
- **UNSORTED**: Desktop folder containing 31,672 disorganized files

### Appendix D: Lock File Format Specification

**Location**: `/tmp/org-lock.json`

**Schema**:
```json
{
  "holder": "string (llm name: claude, claude-2, codex-1, codex-2, gemini)",
  "zone": "integer (1-6) or array of integers",
  "acquired_at": "ISO 8601 timestamp",
  "pid": "integer (optional process ID)",
  "operation": "string (human-readable operation description)",
  "timeout_at": "ISO 8601 timestamp (optional, for auto-release)"
}
```

**Example**:
```json
{
  "holder": "codex-2",
  "zone": 5,
  "acquired_at": "2025-10-20T14:30:00Z",
  "pid": 12345,
  "operation": "UNSORTED folder processing (31,672 files)",
  "timeout_at": "2025-10-20T16:00:00Z"
}
```

---

## Document End

**Next Steps**:
1. Review this plan with all team members
2. Verify pre-flight checklist (Section 6)
3. Execute full backup to D: drive
4. Begin Phase A (all 5 LLMs analyze in parallel)
5. Follow execution sequence strictly
6. Monitor progress via logs
7. Verify success criteria upon completion

**Questions?** Contact: Kyler Rosebrook

**Version**: 1.0.0
**Status**: APPROVED - READY FOR EXECUTION
**Date**: 2025-10-20

---

*This document is the single source of truth for the Multi-LLM File Organization Project. All team members must adhere to protocols defined herein.*
