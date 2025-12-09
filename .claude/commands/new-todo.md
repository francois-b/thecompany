---
description: Create a new TODO item with auto-generated ID
allowed-tools: ["Bash", "Read", "Write", "AskUserQuestion"]
---

Create a new TODO item in docs/todos/.

## Step 1: Get Next ID

Run the ID script to get the next available number:

```bash
~/.claude/scripts/next-doc-id.sh TODO
```

## Step 2: Get TODO Details

Use AskUserQuestion to prompt for:

1. **Title** - Short descriptive title (e.g., "Upgrade Jest", "Add logging")
2. **Severity** - Low | Medium | High

## Step 3: Create the Document

Create the file at `docs/todos/TODO-NNN-kebab-case-title.md` with this template:

```markdown
# TODO-NNN: Title

## Status

Pending

## Problem

What needs to be done and why.

## Solution

How to fix it.

## Impact

- **Severity**: Severity-here
- **Affected**: What parts of the codebase
- **Blocking**: Nothing (or what this blocks)

## Action Required

1. Step one
2. Step two
```

Replace:
- `TODO-NNN` with the actual ID
- `Title` with the provided title
- `Severity-here` with the selected severity
- Convert title to kebab-case for filename

## Step 4: Confirm

Tell the user the file was created and show the path.
