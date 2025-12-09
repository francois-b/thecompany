# Project Documentation Structure Guide

**Purpose:** How to structure documentation for full-stack projects with product and technical decision-making

---

## Overview

This guide documents best practices for organizing project documentation, synthesized from industry research and tailored to small teams and solo developers working with AI assistants.

### Core Principles

1. **Docs-as-code**: Documentation lives in git, versioned alongside code
2. **Single source of truth**: One canonical location for each type of information
3. **Progressive formalization**: Ideas start loose, become structured as they mature
4. **AI-optimized**: Consistent formatting, clear status, easy discoverability

---

## Document Types

### The Documentation Hierarchy

```
Loose Ideas → Design Doc → Implementation → Reference
     ↓            ↓              ↓             ↓
  Scratch     Proposal       Code ships    CLAUDE.md
```

| Stage | Document Type | Purpose | Lifespan |
|-------|--------------|---------|----------|
| **Exploration** | Scratch notes, brainstorms | Capture raw ideas | Temporary |
| **Research** | Research Doc | Deep dives into domains, algorithms, standards | Evergreen reference |
| **Proposal** | Design Doc | Propose, gather feedback, decide, record rationale | Permanent |
| **Reference** | CLAUDE.md, README | Current state of the system | Continuously updated |

---

## Directory Structure

```
docs/
├── README.md              # Master index with lookup tables
├── bugs/                  # Bug reports and fixes
│   ├── README.md
│   └── BUG-001-*.md
├── design/                # Design Docs (proposals → decisions → history)
│   ├── README.md
│   ├── DES-001-*.md
│   └── DES-002-*.md
├── meetings/              # Meeting notes, standups
│   └── README.md
├── meta/                  # Documentation standards (this file)
├── operations/            # Runbooks, deployment guides
│   └── README.md
├── research/              # Domain research (evergreen reference)
│   ├── README.md
│   └── YYYY-MM-DD-*.md
├── reviews/               # Code reviews, audits (date-prefixed)
│   └── README.md
└── todos/                 # TODO items and technical debt
    ├── README.md
    └── TODO-001-*.md
```

### Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Design Doc | `DES-NNN-kebab-case-title.md` | `DES-015-oauth-flow.md` |
| Bug | `BUG-NNN-kebab-case-title.md` | `BUG-003-json-parsing.md` |
| TODO | `TODO-NNN-kebab-case-title.md` | `TODO-005-upgrade-deps.md` |
| Research | `YYYY-MM-DD-kebab-case-topic.md` | `2025-12-06-algorithm-comparison.md` |
| Review | `YYYY-MM-DD-description.md` | `2025-12-05-security-audit.md` |

**Numbering rules:**

- Use sequential numbers (001, 002, 003...)
- Gaps are fine (deleted docs)
- Check existing docs before creating new ones to avoid duplicates
- Numbers must be zero-padded to 3 digits

---

## Research Documents

Research docs capture **domain knowledge and exploration** — they inform Design Docs but aren't decisions themselves.

### Purpose

- Deep dives into algorithms, standards, or technologies
- Comparative analysis of tools or approaches
- Domain expertise that applies to multiple features
- Reference material that doesn't fit elsewhere

### Key Differences from Design Docs

| Aspect | Research Doc | Design Doc |
|--------|--------------|------------|
| **Purpose** | Learn and document knowledge | Propose and decide |
| **Lifecycle** | Evergreen (no status) | Draft → Implemented |
| **Scope** | Domain/technology | Specific feature/change |
| **Output** | Understanding | Decision + implementation |

### Research Doc Template

```markdown
# Topic Name

**Created:** YYYY-MM-DD
**Updated:** YYYY-MM-DD
**Tags:** tag1, tag2, tag3

## Summary

One paragraph overview of what this research covers.

## Background

Why this topic matters. What prompted the research.

## Findings

### Key Concept 1

Details, examples, citations.

### Key Concept 2

Details, examples, citations.

## Implications for This Project

How this research applies specifically.

## References

- [Source 1](url) — Description
- [Source 2](url) — Description
```

### When to Write a Research Doc

Write a research doc when:

- Learning a new domain before designing a feature
- Comparing multiple tools/libraries/approaches
- Documenting standards or protocols (OAuth, WebAuthn, etc.)
- Capturing knowledge that will inform multiple Design Docs

**Don't write a research doc for:**

- Implementation details (put in Design Doc)
- One-off investigations (put in Design Doc "Context" section)
- General notes (keep in scratch files)

---

## The Unified Design Doc Format

Research from [Google](https://www.industrialempathy.com/posts/design-docs-at-google/), [Uber](https://newsletter.pragmaticengineer.com/p/rfcs-and-design-docs), and [industry analysis](https://candost.blog/adrs-rfcs-differences-when-which/) shows that separating RFCs from ADRs creates overhead for small teams. A unified "Design Doc" format that evolves through states is more practical.

### Why Unified?

| Traditional | Problem |
|-------------|---------|
| RFC + ADR | Duplication: RFC says "what", ADR says "why" — often the same document |
| Separate tracking | Status drift: RFCs stay "Draft" forever |
| Rigid templates | Overhead: Not every decision needs 15 sections |

**Our approach**: One Design Doc format that captures both the proposal AND the decision rationale. The "Consequences" section serves the ADR purpose. No separate ADR needed.

### Design Doc Template

```markdown
---
id: DES-NNN
title: Title Here
status: Draft | Reviewing | Accepted | Implemented | Deprecated
area: authentication | data-storage | frontend | mobile | ai | infrastructure
created: YYYY-MM-DD
updated: YYYY-MM-DD
related: [DES-xxx, BUG-xxx]
---

# DES-NNN: Title [STATUS]

**Author:** Name
**Created:** YYYY-MM-DD
**Updated:** YYYY-MM-DD (if modified)

## Summary

One paragraph: What is this about? What problem does it solve?

## Context

Why is this needed now? What forces are at play?
Link to relevant issues, user feedback, or prior discussions.

## Goals

1. What this proposal aims to achieve
2. Measurable if possible

## Non-Goals

1. What is explicitly out of scope
2. Prevents scope creep

## Design

### Overview

High-level approach. Diagrams if helpful.

### Details

Specifics: APIs, data structures, UI flows, algorithms.
Only as detailed as needed for the decision.

## Alternatives Considered

### Alternative 1: Name
- **Description:** What it involves
- **Trade-offs:** Pros and cons
- **Rejected because:** Why not chosen

## Consequences

### Benefits
- What we gain

### Trade-offs
- What we give up or accept

## Open Questions

- [ ] Unresolved issues (remove when resolved)

## Implementation Notes

_Added after implementation. Deviations from plan, gotchas, lessons learned._
```

### Status Lifecycle

```
Draft → Reviewing → Accepted → Implemented
  ↓         ↓          ↓
Abandoned  Rejected   Deprecated (if superseded)
```

| Status | Meaning | Who can change |
|--------|---------|----------------|
| **Draft** | Work in progress, not ready for review | Author |
| **Reviewing** | Open for feedback | Author moves here |
| **Accepted** | Decision made, ready to implement | After review |
| **Implemented** | Complete, now a historical record | After code ships |
| **Deprecated** | Superseded by another design | When replaced |
| **Rejected** | Decided not to do this | After review |
| **Abandoned** | Author stopped pursuing | Author |

### When to Write a Design Doc

From [Google's guidance](https://www.industrialempathy.com/posts/design-docs-at-google/), write a design doc if you answer "yes" to 3+ of:

- [ ] Uncertain about the correct approach?
- [ ] Would senior review benefit the project?
- [ ] Is the design ambiguous or contentious?
- [ ] Does it affect multiple components or teams?
- [ ] Will future developers question this choice?

**Don't write a design doc for:**

- Obvious solutions with minimal trade-offs
- Small bug fixes or typo corrections
- Rapid prototyping where iteration is faster than documentation

---

## AI-Optimized Documentation

### Frontmatter for Discoverability

Add YAML frontmatter to help AI assistants find relevant docs:

```yaml
---
id: DES-015
title: OAuth Flow
status: Implemented
area: authentication
created: 2025-12-01
updated: 2025-12-05
related: [DES-010, DES-012]
---
```

### Status Tags in Titles

For quick scanning, include status in the first line:

```markdown
# DES-015: OAuth Flow [IMPLEMENTED]
```

### Lookup Tables

Maintain a master index (`docs/README.md`) with:

1. **By feature area**: Group related docs
2. **By status**: What's implemented vs proposed
3. **By task**: "I need to..." lookup

### Keep CLAUDE.md Current

The root `CLAUDE.md` should reflect the **current state** of the system:

- Architecture overview
- Key patterns
- API contracts
- Deployment process

Update it when design docs are implemented, not before.

---

## Anti-Patterns to Avoid

| Anti-Pattern | Problem | Better Approach |
|--------------|---------|-----------------|
| **Status drift** | RFCs stay "Draft" forever | Update status when implementation ships |
| **Duplicate content** | Same info in RFC and ADR | One authoritative location (Design Doc) |
| **Over-documentation** | Design doc for trivial changes | Only document decisions with trade-offs |
| **Under-documentation** | Major changes with no record | If future-you will wonder "why?", document |
| **Stale references** | CLAUDE.md describes old architecture | Update reference docs when system changes |
| **Orphan docs** | No index, impossible to discover | Maintain master README with lookup tables |
| **Duplicate numbers** | DES-015 created when DES-015 exists | Check existing docs before creating |

---

## Required Tooling

### Docs-as-Code Stack

| Tool | Purpose | Required |
|------|---------|----------|
| **Git** | Version control, history, blame | Yes |
| **Markdown** | Universal, readable, diffable | Yes |
| **markdownlint** | Consistent markdown formatting | Yes |
| **Vale** | Prose linting for style consistency | Optional |
| **markdown-link-check** | Catch broken cross-references | Yes |
| **MkDocs** | Local browsable documentation site | Optional |

### Local Documentation Site

Use [MkDocs](https://www.mkdocs.org/getting-started/) with [Material theme](https://squidfunk.github.io/mkdocs-material/) to browse docs locally:

```bash
# Start local server (runs on http://localhost:8000)
mkdocs serve

# Build static site (for offline viewing)
mkdocs build
```

---

## References

### Research Sources

- [Design Docs at Google](https://www.industrialempathy.com/posts/design-docs-at-google/) — Google's design doc culture and structure
- [RFCs and Design Docs](https://newsletter.pragmaticengineer.com/p/rfcs-and-design-docs) — Uber's evolution from DUCKs to RFCs
- [ADRs vs RFCs](https://candost.blog/adrs-rfcs-differences-when-which/) — When to use each format
- [Architecture Decision Records](https://adr.github.io/) — ADR community resources

### Tools

- [markdownlint](https://github.com/DavidAnson/markdownlint) — Markdown linting
- [Vale](https://github.com/errata-ai/vale) — Prose linting
- [markdown-link-check](https://github.com/tcort/markdown-link-check) — Link validation
- [MkDocs](https://www.mkdocs.org/) — Static site generator
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) — Theme with search, navigation
