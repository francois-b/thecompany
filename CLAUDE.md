# thecompany

Reusable Claude Code tooling for standups, documentation, and infrastructure monitoring.

Works with both Claude Code desktop/CLI and Claude Code on the web.

## Quick Start

```bash
# Install global commands (run once)
./install.sh

# Initialize docs in a project
./init-docs.sh ~/dev/myproject

# Check symlink health
./setup-doctor.sh ~/dev/myproject
```

## Structure

```
thecompany/
├── .claude/                # Commands and scripts
│   ├── commands/           # Slash commands (auto-loaded on web, symlinked locally)
│   │   ├── standup.md
│   │   ├── new-design-doc.md
│   │   ├── new-bug.md
│   │   ├── new-todo.md
│   │   └── new-research.md
│   └── scripts/            # Supporting scripts
│       ├── standup-data.sh
│       ├── next-doc-id.sh
│       └── prompt-aws-creds.sh
├── docs-meta/              # Meta guides → project/docs/meta/
├── docs-templates/         # README templates → project/docs/*/README.md
├── configs/                # Linting configs → project root
├── templates/              # Copied (not symlinked)
├── install.sh              # Local installation (desktop/CLI)
├── web-install.sh          # Web installation (SessionStart)
├── init-docs.sh            # Per-project docs setup
└── setup-doctor.sh         # Health check and fix
```

## Commands

| Command | Description |
|---------|-------------|
| `/standup` | Project standup with AWS status, costs, pending work |
| `/new-design-doc` | Create a design doc with auto-generated ID |
| `/new-bug` | Create a bug report with auto-generated ID |
| `/new-todo` | Create a TODO item with auto-generated ID |
| `/new-research` | Create a research doc with date prefix |

## Installation

**Web:** Add SessionStart hook to your project's `.claude/settings.json` (see README.md).

**Local:** Run `./install.sh` once to create symlinks in `~/.claude/`.

## Scripts

| Script | Usage |
|--------|-------|
| `install.sh [path]` | Sets up global symlinks, optionally init docs in a project |
| `init-docs.sh <path>` | Initializes docs structure in a project (standalone) |
| `setup-doctor.sh [paths...]` | Checks and fixes broken symlinks |

## Adding New Commands

1. Create `.claude/commands/newcmd.md` with frontmatter and instructions
2. Reference scripts via `~/.claude/scripts/` (absolute path via symlinks)
3. Run `./install.sh` to symlink locally (web auto-loads from .claude/)

## Project Docs Structure

After running `init-docs.sh`, a project gets:

```
project/
├── docs/
│   ├── README.md          # Copied (project-specific index)
│   ├── meta/              # Symlink → thecompany/docs-meta/
│   ├── bugs/README.md     # Symlink
│   ├── design/README.md   # Symlink
│   ├── meetings/README.md # Symlink
│   ├── operations/README.md
│   ├── research/README.md
│   ├── reviews/README.md
│   └── todos/README.md
├── .markdownlint.jsonc    # Symlink
├── .vale.ini              # Symlink
└── .markdown-link-check.json # Symlink
```

## Conventions

- Commands reference scripts via `~/.claude/scripts/` (works on both web and local)
- Per-project config lives in each project's root (e.g., `.standup-config.json`)
- Scripts should work in isolated web VMs (no persistent home directory)
- Web sessions use `web-install.sh` via SessionStart hook to recreate `~/.claude/`
- Symlinked content updates automatically when thecompany changes
