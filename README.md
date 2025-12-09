# thecompany

Reusable Claude Code tooling for project standups and infrastructure monitoring.

Works with both Claude Code desktop/CLI and Claude Code on the web.

## Installation

### For Claude Code on the Web

To use these commands in **other projects** on the web (e.g., `project-a`, `project-b`):

1. **Add a SessionStart hook** to your project's `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'if [ ! -d ~/.thecompany ]; then git clone https://github.com/francois-b/thecompany ~/.thecompany; fi && bash ~/.thecompany/web-install.sh'"
          }
        ]
      }
    ]
  }
}
```

2. **What this does:**
   - Clones `thecompany` and `theteam` repos to the web VM (once per session)
   - Creates `~/.claude/` directory structure
   - Symlinks all commands and scripts from both repos
   - Now `/standup` and other commands work in your project!

A template is available in `templates/claude-settings-web.json`.

### For Claude Code Desktop/CLI (Local)

Run once to install globally across all your local projects:

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
├── install.sh                      # Local installation script (desktop/CLI)
├── web-install.sh                  # Web installation script (called by SessionStart)
├── .claude/                        # Command and script storage
│   ├── commands/
│   │   └── standup.md              # Slash command
│   └── scripts/
│       └── standup-data.sh         # Data collection script
├── templates/
│   ├── standup-config.json         # Per-project config template
│   └── claude-settings-web.json    # SessionStart hook template for web
├── commands/                       # Legacy (deprecated)
└── scripts/                        # Legacy (deprecated)
```

## Related

- `~/dev/theteam` - Persona management (separate concern)
