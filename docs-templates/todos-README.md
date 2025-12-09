# TODO Items

Pending work items that don't fit into bug or design doc categories — typically small technical debt, dependency updates, or deferred maintenance.

## Creating a New TODO

Use the slash command:

```
/new-todo
```

Or manually:

1. Find the next number: `~/.claude/scripts/next-doc-id.sh TODO`
2. Create file: `TODO-NNN-short-title.md`
3. Use the template below

## Template

```markdown
# TODO-NNN: Short Title

## Status

Pending | In Progress | Completed | Deferred

## Problem

What needs to be done and why.

## Solution

How to fix it.

## Impact

- **Severity**: Low | Medium | High
- **Affected**: What parts of the codebase
- **Blocking**: What this blocks (if anything)

## Action Required

Steps to complete this TODO.
```

## Status Legend

| Status | Meaning |
|--------|---------|
| **Pending** | Not yet started |
| **In Progress** | Currently being worked on |
| **Completed** | Done |
| **Deferred** | Postponed (with rationale) |

## Current TODOs

| ID | Title | Status |
|----|-------|--------|
<!-- Add entries as: | [TODO-NNN](./TODO-NNN-title.md) | Title | Status | -->
