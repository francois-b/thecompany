---
description: Project standup with AWS status, costs, and pending work
allowed-tools: ["Bash", "Read", "Write", "Glob", "Grep", "AskUserQuestion"]
---

Generate a comprehensive project standup. Display a rich terminal overview and optionally save to meeting notes.

## Step 0: Check Configuration

First, check if `.standup-config.json` exists and has `project_name` set:

```bash
cat .standup-config.json 2>/dev/null || echo "{}"
```

If `project_name` is empty or the file doesn't exist, use AskUserQuestion to prompt:

1. **Project name** - Display name for the standup header (e.g., "SpaceTimeCards", "MyApp")
2. **Stack prefix** - CloudFormation stack name prefix to filter (e.g., "STC", "MyApp") - leave empty if not using AWS
3. **Pipeline name** - CodePipeline name (e.g., "myapp-pipeline") - leave empty if not using CodePipeline
4. **Frontend directories** - Comma-separated list of frontend paths (e.g., "frontend,admin-frontend")

Then write the config to `.standup-config.json`:

```json
{
  "project_name": "...",
  "stack_prefix": "...",
  "pipeline_name": "...",
  "todos_path": "docs/todos",
  "design_docs_path": "docs/design",
  "meeting_notes_path": "docs/meeting-notes",
  "mobile": {
    "android_apk_path": "android/app/build/outputs/apk/debug",
    "ios_app_path": "ios/build/Build/Products/Debug-iphonesimulator"
  },
  "frontends": ["frontend1", "frontend2"]
}
```

## Step 1: Gather Data

Run the standup data collection script:

```bash
~/.claude/scripts/standup-data.sh
```

This outputs sections delimited by `=== SECTION_NAME ===` markers.

## Step 2: Display Rich Terminal Output

Use decorative section headers with emoji and underlines. Format based on what data is available.

**First, generate a pep talk paragraph** to display right after the header. Write it in the style of a hype man / intense motivational speaker addressing a team. It should:
- Be 4-6 sentences, high energy, ALL CAPS on key phrases
- Address the team collectively ("we", "us", "team", "champions")
- Include phrases like "We can do this!", "The time is NOW", "we're gonna make shit happen"
- Be purpose-driven (our work matters, we're solving real problems, making an impact)
- End with a rallying cry to dive into the standup
- Be different every time - vary the structure, phrases, and energy

Example (DO NOT copy verbatim, create fresh variations):
> What a TEAM. What a crew. You all woke up today and chose to BUILD. We can do this! The time is NOW and we're gonna make shit happen TOGETHER! Every line of code we write solves a real problem for real people. Our work MATTERS. Someone out there is going to have a better day because of what we ship. We're not here to participate—we're here to DOMINATE. To CREATE. To leave our mark. And guess what? We're getting stronger every single day. NOW LET'S GO! Let's see what we've crushed and what greatness is coming next!

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🚀 {PROJECT_NAME} STANDUP                                {YYYY-MM-DD}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{PEP_TALK_PARAGRAPH}


☁️  AWS INFRASTRUCTURE (if stack_prefix configured)
────────────────────────────────────────

Stacks:
  ✅ StackName          STATUS   Date
  ...

Pipeline: (if pipeline_name configured)
  ✅ Stage1 → ✅ Stage2 → ...


💰 AWS COSTS (Month-to-Date)
────────────────────────────────────────

Total: $X.XX (estimated)

  Service Name     $X.XX  ████████████████░░░░░░░░░░░░░░  XX%
  ...


📱 MOBILE APPS (if android/ios directories exist)
────────────────────────────────────────

Android · Last build: Date (size)
  • (hash1) commit message
  • (hash2) commit message

iOS · Last build: Date
  • (hash1) commit message
  • (hash2) commit message


🌐 FRONTENDS (for each configured frontend)
────────────────────────────────────────

{frontend-name}
  • (hash1) commit message
  • (hash2) commit message


📝 RECENT ACTIVITY
────────────────────────────────────────

  Category1       ███░░░░░░░   X commits
  Category2       █████████░   X commits
  ...


📋 PENDING WORK (if todos/design docs exist)
────────────────────────────────────────

TODOs (X pending · Y completed)
  🔴 TODO-001  Title
  ...

Design Docs (X draft · Y implemented)
  📝 DES-001  Title
  ...


🎯 NEXT STEPS
────────────────────────────────────────

  1. Contextual suggestion based on pending work
  2. Another suggestion
  3. Third suggestion

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Adapt the output:**
- Skip sections that have no data (e.g., no AWS stacks, no mobile apps)
- Group git commits by detected areas (infrastructure, frontend, mobile, docs, etc.)
- Generate contextual next steps based on what's pending

## Step 3: Ask to Save

After displaying, use AskUserQuestion to ask:
"Save this standup to {meeting_notes_path}/standup-{YYYY-MM-DD}.md?"

Options:
- Yes, save it
- No, don't save

If saving:
1. Create the meeting notes directory if needed: `mkdir -p {meeting_notes_path}`
2. Write markdown version (no decorative lines) to `{meeting_notes_path}/standup-{YYYY-MM-DD}.md`
3. Confirm with file path
