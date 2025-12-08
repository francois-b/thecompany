# thecompany

Reusable Claude Code tooling for project standups and infrastructure monitoring.

## Installation

```bash
# From any project directory
~/dev/thecompany/install.sh .

# Or specify a target
~/dev/thecompany/install.sh ~/dev/myproject
```

This copies:
- `.claude/commands/standup.md` - The standup slash command
- `scripts/standup-data.sh` - Data collection script
- `.standup-config.json` - Configuration template

## Usage

```bash
# In Claude Code
/standup
```

On first run, you'll be prompted to configure:
- **Project name** - Display name for headers
- **Stack prefix** - CloudFormation stack filter (e.g., "STC")
- **Pipeline name** - CodePipeline name
- **Frontend directories** - Paths to frontend apps

Configuration is saved to `.standup-config.json`.

## Configuration

Edit `.standup-config.json` to customize:

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
Bash(./scripts/standup-data.sh:*)
```

## Structure

```
thecompany/
├── install.sh              # Installation script
├── commands/
│   └── standup.md          # Slash command template
├── scripts/
│   └── standup-data.sh     # Data collection script
└── templates/
    └── standup-config.json # Config template
```

## Related

- `~/dev/theteam` - Persona management (separate concern)
