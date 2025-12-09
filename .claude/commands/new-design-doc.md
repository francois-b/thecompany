---
description: Create a new design document with auto-generated ID
allowed-tools: ["Bash", "Read", "Write", "AskUserQuestion"]
---

Create a new design document in docs/design/.

## Step 1: Get Next ID

Run the ID script to get the next available number:

```bash
~/.claude/scripts/next-doc-id.sh DES
```

## Step 2: Get Document Details

Use AskUserQuestion to prompt for:

1. **Title** - Short descriptive title (e.g., "OAuth Flow", "Caching Strategy")
2. **Area** - Feature area: authentication | data-storage | frontend | mobile | ai | infrastructure | other

## Step 3: Create the Document

Create the file at `docs/design/DES-NNN-kebab-case-title.md` with this template:

```markdown
---
id: DES-NNN
title: Title Here
status: Draft
area: area-here
created: YYYY-MM-DD
updated: YYYY-MM-DD
related: []
---

# DES-NNN: Title [DRAFT]

**Author:** (your name)
**Created:** YYYY-MM-DD

## Summary

One paragraph: What is this about? What problem does it solve?

## Context

Why is this needed now? What forces are at play?

## Goals

1. What this proposal aims to achieve
2. Measurable if possible

## Non-Goals

1. What is explicitly out of scope

## Design

### Overview

High-level approach. Diagrams if helpful.

### Details

Specifics: APIs, data structures, UI flows, algorithms.

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

- [ ] Unresolved issues

## Implementation Notes

_Added after implementation._
```

Replace:
- `DES-NNN` with the actual ID
- `Title` with the provided title
- `YYYY-MM-DD` with today's date
- `area-here` with the selected area
- Convert title to kebab-case for filename

## Step 4: Confirm

Tell the user the file was created and show the path.
