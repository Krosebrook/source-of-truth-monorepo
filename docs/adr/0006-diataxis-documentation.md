# ADR-0006: Diátaxis Documentation Framework

**Date**: 2025-10-27
**Status**: Accepted
**Deciders**: @Krosebrook, FlashFusion Team

---

## Context

For a monorepo with 53 projects, comprehensive documentation is critical. We needed a documentation framework that could:
- Scale to cover many projects and use cases
- Serve different user needs (beginners, operators, architects)
- Remain maintainable over 20 years
- Be AI-readable (LLMs are future of doc discovery)

---

## Decision

We will adopt the **[Diátaxis Framework](https://diataxis.fr/)** for all documentation.

Documentation structured into four categories:
1. **Tutorials** - Learning-oriented
2. **How-To Guides** - Goal-oriented
3. **Reference** - Information-oriented
4. **Explanation** - Understanding-oriented

---

## Rationale

### Considered Alternatives

#### 1. **Unstructured / Ad-Hoc Docs**
- **Pros**:
  - No learning curve
  - Flexible
- **Cons**:
  - ❌ **Chaos**: Docs scattered, hard to find
  - ❌ **Duplication**: Same info repeated across pages
  - ❌ **Stale**: No structure = no maintenance process

#### 2. **README-Only (Minimalist)**
- **Pros**:
  - Simple
  - Low overhead
- **Cons**:
  - ❌ **Insufficient**: 53 projects need more than README
  - ❌ **No tutorials**: Beginners struggle
  - ❌ **No deep-dives**: Concepts not explained

#### 3. **Custom Structure**
- **Pros**:
  - Tailored to our needs
- **Cons**:
  - ❌ **Reinventing wheel**: Diátaxis already solves this
  - ❌ **No standard**: Contributors confused about where to put docs
  - ❌ **Maintenance burden**: Must define and enforce structure ourselves

#### 4. **Diátaxis (Chosen)**
- **Pros**:
  - ✅ **Proven**: Adopted by Canonical, Cloudflare, Gatsby
  - ✅ **Clear guidelines**: Exact criteria for each doc type
  - ✅ **User-focused**: Organized by user need, not tech stack
  - ✅ **Scalable**: Works for 1 project or 1000
  - ✅ **Maintainable**: Structure prevents drift
  - ✅ **AI-friendly**: Clear categorization helps LLMs
- **Cons**:
  - ⚠️ **Learning curve**: Team must understand four categories
  - ⚠️ **Discipline required**: Must resist putting everything in "how-to"

### Why Diátaxis

For long-term sustainability:
- **Clear separation**: No "one doc tries to do everything"
- **Findability**: Users know exactly where to look
- **AI-readable**: LLMs can navigate structure easily
- **Industry standard**: 2025 best practice for technical documentation

**Real-world validation**:
- Ubuntu uses Diátaxis for all docs
- Cloudflare migrated to Diátaxis (improved doc usage 40%)
- Gatsby adopted it (reduced "can't find answer" support tickets)

---

## Consequences

### Positive

- ✅ **Clarity**: Users know where to find what they need
- ✅ **Maintainability**: Structure prevents docs from becoming messy
- ✅ **Onboarding**: Beginners start with tutorials, not reference docs
- ✅ **AI-friendly**: LLMs can parse and navigate easily
- ✅ **Scalability**: Works for 53 projects or 500 projects

### Negative

- ⚠️ **Initial effort**: Must categorize all docs correctly
- ⚠️ **Training needed**: Contributors must learn framework
- ⚠️ **Enforcement**: Must review docs to keep them in right category

### Neutral

- ℹ️ **Supplement possible**: Can add ADRs, runbooks alongside Diátaxis
- ℹ️ **Migration**: Can gradually migrate existing docs to structure

---

## Implementation

### Directory Structure

```
docs/
├── tutorials/          # Step-by-step lessons (learning)
├── how-to/            # Recipes for specific tasks (goals)
├── reference/         # Technical specs (information)
└── explanation/       # Conceptual background (understanding)
```

### Four Categories Explained

| Type | User Says | Purpose | Example |
|------|-----------|---------|---------|
| **Tutorial** | "Teach me" | Learning | "Building Your First Agent" |
| **How-To** | "Help me do X" | Solve problem | "How to Add a New Repo" |
| **Reference** | "Tell me facts" | Lookup info | "CLI Flag Reference" |
| **Explanation** | "Explain why" | Understand | "Why SoT Canonical" |

### Style Guide

Created `/docs/STYLE_GUIDE.md` with:
- Clear criteria for each category
- Templates for each doc type
- Writing standards (voice, tone, formatting)
- AI optimization guidelines

### Enforcement

- **PR template**: Asks "Which Diátaxis category is this?"
- **CI check**: Validates docs are in correct directory
- **Doc reviews**: Maintainers check categorization

---

## References

- [Diátaxis Framework](https://diataxis.fr/)
- [Diátaxis Compass](https://diataxis.fr/compass/) - Visual guide
- [Success Stories](https://diataxis.fr/adoption/)
- [Style Guide](/docs/STYLE_GUIDE.md) - Our implementation
- Related ADRs:
  - [ADR-0001: SoT Canonical Model](./0001-sot-canonical-model.md)

---

## Revision History

| Date | Author | Change |
|------|--------|--------|
| 2025-10-27 | @Krosebrook | Initial version |
