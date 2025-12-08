# thecompany

Reusable Claude Code tooling for project standups and infrastructure monitoring.

## Installation

Run once to install globally:

```bash
~/dev/thecompany/install.sh
```

This creates symlinks in `~/.claude/` pointing to this repo:
- `~/.claude/commands/standup.md` → Slash command
- `~/.claude/scripts/standup-data.sh` → Data collection script

Changes to files in this repo apply immediately to all projects.

## Usage

```bash
# In Claude Code (any project)
/standup
```

On first run in a project, you'll be prompted to configure:
- **Project name** - Display name for headers
- **Stack prefix** - CloudFormation stack filter (e.g., "STC")
- **Pipeline name** - CodePipeline name
- **Frontend directories** - Paths to frontend apps

Configuration is saved to `.standup-config.json` in each project.

## Configuration

Each project's `.standup-config.json`:

```json
{
  "project_name": "MyApp",
  "stack_prefix": "MA",
  "pipeline_name": "myapp-pipeline",
  "todos_path": "docs/todos",
  "design_docs_path": "docs/design",
  "meeting_notes_path": "docs/meeting-notes",
  "mobile": {
    "android_apk_path": "android/app/build/outputs/apk/debug",
    "ios_app_path": "ios/build/Build/Products/Debug-iphonesimulator"
  },
  "frontends": ["frontend", "admin"]
}
```

## Adding to Allowed Commands

To run `/standup` without permission prompts, add to your Claude Code settings:

```
Bash(~/.claude/scripts/standup-data.sh:*)
```

## Structure

```
thecompany/
├── install.sh              # Global installation script
├── commands/
│   └── standup.md          # Slash command (symlinked to ~/.claude/commands/)
├── scripts/
│   └── standup-data.sh     # Data collection (symlinked to ~/.claude/scripts/)
└── templates/
    └── standup-config.json # Config template (for reference)
```

## Related

- `~/dev/theteam` - Persona management (separate concern)
