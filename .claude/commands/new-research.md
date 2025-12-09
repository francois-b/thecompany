---
description: Create a new research document with date prefix
allowed-tools: ["Bash", "Read", "Write", "AskUserQuestion"]
---

Create a new research document in docs/research/.

## Step 1: Get Document Details

Use AskUserQuestion to prompt for:

1. **Topic** - Research topic (e.g., "OAuth comparison", "Caching strategies")
2. **Tags** - Comma-separated tags (e.g., "authentication, security, oauth")

## Step 2: Create the Document

Get today's date and create the file at `docs/research/YYYY-MM-DD-kebab-case-topic.md` with this template:

```markdown
# Topic Name

**Created:** YYYY-MM-DD
**Updated:** YYYY-MM-DD
**Tags:** tags-here

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

Replace:
- `Topic Name` with the provided topic
- `YYYY-MM-DD` with today's date
- `tags-here` with the provided tags
- Convert topic to kebab-case for filename

## Step 3: Confirm

Tell the user the file was created and show the path.
