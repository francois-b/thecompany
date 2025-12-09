---
description: Create a new bug report with auto-generated ID
allowed-tools: ["Bash", "Read", "Write", "AskUserQuestion"]
---

Create a new bug report in docs/bugs/.

## Step 1: Get Next ID

Run the ID script to get the next available number:

```bash
~/.claude/scripts/next-doc-id.sh BUG
```

## Step 2: Get Bug Details

Use AskUserQuestion to prompt for:

1. **Title** - Short descriptive title (e.g., "Login fails on mobile", "API timeout")
2. **Severity** - Critical | High | Medium | Low

## Step 3: Create the Document

Create the file at `docs/bugs/BUG-NNN-kebab-case-title.md` with this template:

```markdown
# BUG-NNN: Title

## Summary

One-line description of the bug.

## Status

Open

## Severity

Severity-here

## Steps to Reproduce

1. Step one
2. Step two
3. Observe issue

## Expected Behavior

What should happen.

## Actual Behavior

What actually happens.

## Root Cause

_To be determined._

## Fix Applied

_Not yet fixed._

## Related Documents

- Links to relevant design docs or PRs
```

Replace:
- `BUG-NNN` with the actual ID
- `Title` with the provided title
- `Severity-here` with the selected severity
- Convert title to kebab-case for filename

## Step 4: Confirm

Tell the user the file was created and show the path.
