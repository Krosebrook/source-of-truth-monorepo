# FlashFusion SoT Documentation Style Guide

> Writing standards for veteran-grade, AI-optimized, 20-year forward-looking documentation

**Framework**: [Diátaxis](https://diataxis.fr/)
**Optimization**: LLMs.txt v1.0, MCP v1.0
**Standard**: [Google Documentation Style Guide](https://google.github.io/styleguide/docguide/)

---

## Core Principles

1. **Write for humans first, AI second** - Clarity over optimization
2. **One source of truth** - Don't duplicate information
3. **Docs-as-Code** - Treat docs like code (version control, review, CI/CD)
4. **Living documentation** - Update when code changes
5. **Accessibility** - Works for all skill levels and abilities

---

## Diátaxis Framework (Structure)

Every document must fit into one of four categories:

| Type | Purpose | User Need | Focus | Example |
|------|---------|-----------|-------|---------|
| **Tutorial** | Learning | "Teach me" | Step-by-step lesson | Building Your First Agent |
| **How-To** | Goals | "Help me solve X" | Practical solution | How to Add a New Repo |
| **Reference** | Information | "Tell me facts" | Technical specs | CLI Flag Reference |
| **Explanation** | Understanding | "Explain why" | Concepts/context | Why SoT Canonical |

### Where to Place Documents

```
docs/
├── tutorials/         # Learning-oriented (hands-on)
├── how-to/           # Goal-oriented (problem-solving)
├── reference/        # Information-oriented (specs)
└── explanation/      # Understanding-oriented (concepts)
```

---

## Writing Style

### Voice & Tone
- **Active voice**: "Run `pnpm install`" (not "pnpm install should be run")
- **Present tense**: "The agent validates" (not "will validate" or "validated")
- **Second person**: "You can configure" (not "one can configure")
- **Conversational**: Write like you're explaining to a colleague

### Clarity
- **Short sentences**: Max 25 words (complex ideas = multiple sentences)
- **Short paragraphs**: 3-5 lines max (one idea per paragraph)
- **Active verbs**: "Create", "Build", "Deploy" (not "there is", "it can be")
- **Simple words**: "Use" not "utilize", "Start" not "commence"

### Technical Accuracy
- **Precision**: "pnpm 9.x" not "latest pnpm"
- **Verification**: Test all code examples before committing
- **Currency**: Date-stamp docs with version/date if time-sensitive

---

## Terminology (Use Consistently)

### Standard Terms

| **Use This** | **Not This** | **Context** |
|--------------|--------------|-------------|
| SoT | source of truth, source-of-truth | Source-of-Truth monorepo |
| mirror | downstream repo, fork | Repositories synced from SoT |
| workspace | monorepo packages, projects | pnpm workspace |
| project | package, module | Individual repository in workspace |
| Turbo | TurboRepo, turborepo | Build system (proper noun) |
| pnpm | PNPM, Pnpm | Package manager |
| Diátaxis | Diataxis, diataxis | Documentation framework (proper noun with accent) |
| Changesets | changesets | Versioning tool (proper noun) |

### FlashFusion-Specific Terms

- **SoT Canonical Model**: Development model where SoT is source of truth
- **Agent Parity**: Unified interface across all 4 AI agents
- **Independent Versioning**: Each project versions separately
- **Flattened Repo**: Repository without git history (for imports)

---

## Formatting

### Headings

```markdown
# Page Title (H1 - One per page)

## Section (H2)

### Subsection (H3)

#### Sub-subsection (H4 - Rare, avoid if possible)
```

**Rules**:
- **One H1** per page (page title)
- **Descriptive**: "How to Add a New Repository" (not "Adding Repositories")
- **No vague titles**: "Authentication Flow" not "Overview"
- **Sentence case**: "Getting started" (not "Getting Started")

### Code Blocks

Always specify language:

````markdown
```bash
pnpm install
```

```typescript
const config: Config = { ... }
```

```json
{
  "name": "example"
}
```
````

### Inline Code

Use backticks for:
- Commands: `pnpm install`
- File paths: `/docs/index.md`
- Variable names: `packageManager`
- Config keys: `turbo.json`

### Lists

**Ordered** (steps, sequence):
```markdown
1. Install dependencies
2. Run build
3. Test locally
```

**Unordered** (items, no order):
```markdown
- TypeScript
- JavaScript
- Python
```

### Links

**Internal** (same repo):
```markdown
See [Getting Started](/GETTING_STARTED.md)
```

**External**:
```markdown
Read [Diátaxis](https://diataxis.fr/)
```

**Reference style** (long URLs):
```markdown
See the [Google Style Guide][1]

[1]: https://google.github.io/styleguide/docguide/
```

### Tables

```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Data     | Data     | Data     |
```

**Rules**:
- **Headers**: Always include
- **Alignment**: Left-align text, right-align numbers
- **Width**: Keep narrow (max 120 chars per row)

### Admonitions

```markdown
> **Note**: Informational callout

> **Warning**: Caution required

> **Tip**: Helpful suggestion
```

---

## AI Optimization (LLM-Readable)

### For LLMs to Parse Well

1. **Clear headings**: Use descriptive, specific titles
2. **Consistent terminology**: Pick one term, use it everywhere
3. **Proper code formatting**: Always specify language in code blocks
4. **Short paragraphs**: 3-5 lines max (helps AI chunk cleanly)
5. **Structured data**: Use tables, lists, YAML frontmatter

### Frontmatter (Optional but Recommended)

```markdown
---
title: "How to Add a New Repository"
category: how-to
tags: [git, subtree, import]
difficulty: intermediate
estimated_time: 15 minutes
last_updated: 2025-10-27
---
```

### LLMs.txt Compliance

- **Index important docs** in `.llms.txt`
- **Use consistent paths**: Absolute from repo root
- **Link to schemas**: Reference `/shared/contracts/agent-output.schema.json`

---

## File Naming

### Conventions

```
kebab-case-with-dashes.md   # ✅ Good
PascalCase.md               # ❌ Bad
snake_case.md               # ❌ Bad
spaces in name.md           # ❌ Bad
```

### Prefixes

```
docs/tutorials/01-quickstart.md     # Numbered sequence
docs/how-to/add-repository.md       # Descriptive action
docs/adr/0001-sot-canonical.md      # ADRs numbered
```

---

## Document Templates

### Tutorial Template

```markdown
# [Tutorial Name]

> Brief description of what you'll learn

**Time**: 15 minutes
**Level**: Beginner
**Prerequisites**: None

## What You'll Build

[Describe end result]

## Steps

### Step 1: [Action]

[Instructions]

```bash
[commands]
```

### Step 2: [Action]

[Continue...]

## What You Learned

- Point 1
- Point 2

## Next Steps

- [Link to related tutorial]
- [Link to reference docs]
```

### How-To Template

```markdown
# How to [Achieve Goal]

> Quick reference for [specific task]

**Use case**: [When to use this guide]

## Prerequisites

- Requirement 1
- Requirement 2

## Steps

1. [Action step with command/code]
2. [Action step with command/code]
3. [Action step with command/code]

## Verification

[How to verify it worked]

## Troubleshooting

**Problem**: [Common issue]
**Solution**: [How to fix]

## Related

- [Link to explanation]
- [Link to reference]
```

### Reference Template

```markdown
# [Component/API Name]

> Technical specification for [X]

## Overview

[Brief description]

## Syntax

```typescript
[Code signature]
```

## Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| param1 | string | Yes | Description |

## Examples

```typescript
[Working examples]
```

## See Also

- [Related reference]
```

### Explanation Template

```markdown
# [Concept Name]

> Understanding [concept]

## The Problem

[What problem does this solve?]

## The Solution

[How does this concept solve it?]

## Why It Matters

[Context and rationale]

## Trade-offs

**Advantages**:
- Point 1
- Point 2

**Disadvantages**:
- Point 1
- Point 2

## When to Use

[Guidelines for adoption]

## Further Reading

- [Link to ADR]
- [Link to tutorial]
```

---

## Review Checklist

Before committing documentation:

- [ ] **Diátaxis category** clear (tutorial/how-to/reference/explanation)
- [ ] **Spelling & grammar** checked
- [ ] **Code examples** tested and working
- [ ] **Links** verified (no 404s)
- [ ] **Terminology** consistent (SoT, mirror, workspace)
- [ ] **Headings** descriptive and hierarchical
- [ ] **AI-readable** (short paragraphs, clear headings)
- [ ] **Markdownlint** passing (see `.markdownlint.json`)
- [ ] **Frontmatter** added (if applicable)
- [ ] **Updated** `.progress.yaml` if completing task

---

## Maintenance

### Staleness Detection

Docs older than **6 months** should be reviewed for accuracy.

### Ownership

Every doc should have an owner (via CODEOWNERS or frontmatter `maintainer` field).

### Deprecation

When removing docs:
1. Add deprecation notice for 1 month
2. Redirect to replacement doc
3. Archive (don't delete) after 1 month

---

## Resources

- [Diátaxis Framework](https://diataxis.fr/)
- [Google Documentation Style Guide](https://google.github.io/styleguide/docguide/)
- [LLMs.txt Standard](https://llmstxt.org/)
- [Markdown Guide](https://www.markdownguide.org/)
- [CommonMark Spec](https://commonmark.org/)

---

**Questions?** See `/docs/meta/best-practices.md` or open an issue.
