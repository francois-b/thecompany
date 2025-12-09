# Bug Reports

Documented bugs, their root causes, and fixes applied.

## Creating a New Bug Report

Use the slash command:

```
/new-bug
```

Or manually:

1. Find the next number: `~/.claude/scripts/next-doc-id.sh BUG`
2. Create file: `BUG-NNN-kebab-title.md`
3. Use the template below

## Template

```markdown
# BUG-NNN: Short Title

## Summary

One-line description of the bug.

## Status

Open | Fixed | Won't Fix

## Severity

Critical | High | Medium | Low

## Steps to Reproduce

1. Step one
2. Step two
3. Observe issue

## Root Cause

Technical explanation of why the bug occurs.

## Fix Applied

What was changed to fix the bug.

## Related Documents

- Links to relevant design docs or PRs
```

## Status Legend

| Status | Meaning |
|--------|---------|
| **Open** | Bug confirmed, not yet fixed |
| **Fixed** | Fix has been applied |
| **Won't Fix** | Decided not to fix (with rationale) |
