# thecompany

Reusable Claude Code tooling for project documentation and standups, distributed via global symlinks.

Works with both Claude Code desktop/CLI and Claude Code on the web.

## Installation

### For Claude Code on the Web

To use these commands in **other projects** on the web (e.g., `project-a`, `project-b`):

**Add a SessionStart hook** to your project's `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'if [ ! -d ~/.thecompany ]; then git clone https://github.com/francois-b/thecompany ~/.thecompany; fi && bash ~/.thecompany/web-install.sh && bash ~/.claude/scripts/prompt-aws-creds.sh'"
          }
        ]
      }
    ]
  }
}
```

**What this does:**
1. Clones `thecompany` repo to `~/.thecompany` (once per session)
2. Runs `web-install.sh` which clones `theteam` and sets up `~/.claude/` symlinks
3. Prompts for AWS credentials (press Enter to skip if not needed)
4. All commands from both repos are now available: `/standup`, persona commands, etc.

A template is available in `templates/claude-settings-web.json`.

### For Claude Code Desktop/CLI (Local)

Run once to install globally across all your local projects:

```bash
~/dev/thecompany/install.sh
```

This creates symlinks in `~/.claude/` for all commands and scripts.

### Initialize Docs in a Project

```bash
~/dev/thecompany/init-docs.sh ~/dev/myproject
```

This sets up the docs structure with symlinks back to thecompany.

### Health Check

```bash
~/dev/thecompany/setup-doctor.sh ~/dev/myproject ~/dev/another-project
```

Checks and fixes broken symlinks (useful if thecompany repo moves).

## AWS Credentials

The `/standup` command displays AWS infrastructure data (CloudFormation stacks, CodePipeline status, Cost Explorer) if credentials are available.

### Local (Desktop/CLI)
If you have AWS credentials configured locally (via `~/.aws/credentials` or environment variables), `/standup` will automatically use them.

### Web
AWS credentials are **not** available by default on the web (ephemeral VMs don't have access to your local credentials). You have two options:

1. **Skip AWS features** (default) - `/standup` works but skips CloudFormation/CodePipeline/Costs sections
2. **Prompt for credentials** - Add `prompt-aws-creds.sh` to your SessionStart hook (see installation above)

Credentials entered via the prompt are stored in `CLAUDE_ENV_FILE` and persist for the entire session, but are **not** saved between sessions (you'll be prompted again next time).

## Available Commands

| Command | Description |
|---------|-------------|
| `/standup` | Project standup with AWS status, costs, pending work |
| `/new-design-doc` | Create a design doc with auto-generated ID |
| `/new-bug` | Create a bug report with auto-generated ID |
| `/new-todo` | Create a TODO item with auto-generated ID |
| `/new-research` | Create a research doc with date prefix |

## Project Docs Structure

After running `init-docs.sh`, a project gets:

```
project/
├── docs/
│   ├── README.md          # Project-specific index (copied)
│   ├── meta/              # Symlink → documentation guidelines
│   ├── bugs/              # Bug reports
│   ├── design/            # Design documents
│   ├── meetings/          # Meeting notes
│   ├── operations/        # Runbooks
│   ├── research/          # Domain research
│   ├── reviews/           # Code reviews, audits
│   └── todos/             # TODO items
├── .markdownlint.jsonc    # Symlink → linting config
├── .vale.ini              # Symlink → prose linting
├── .markdown-link-check.json # Symlink → link checking
└── mkdocs.yml             # Project-specific (copied)
```

## How Symlinks Work

- **Symlinked content** (meta/, README.md in each folder, configs): Changes in thecompany propagate instantly to all projects
- **Copied content** (docs/README.md, mkdocs.yml): Project-specific, won't update automatically

## Repo Structure

```
thecompany/
├── install.sh                      # Local installation script (desktop/CLI)
├── web-install.sh                  # Web installation script (called by SessionStart)
├── init-docs.sh                    # Per-project docs setup
├── setup-doctor.sh                 # Health check and fix
├── .claude/                        # Command and script storage
│   ├── commands/
│   │   ├── standup.md
│   │   ├── new-design-doc.md
│   │   ├── new-bug.md
│   │   ├── new-todo.md
│   │   └── new-research.md
│   └── scripts/
│       ├── standup-data.sh
│       ├── next-doc-id.sh
│       └── prompt-aws-creds.sh
├── docs-meta/                      # Meta guides (symlinked to project/docs/meta/)
├── docs-templates/                 # README templates (symlinked per-folder)
├── configs/                        # Linting configs (symlinked to project root)
└── templates/
    ├── standup-config.json
    ├── docs-README.md
    ├── mkdocs.yml
    └── claude-settings-web.json
```

## Adding New Commands

1. Create `.claude/commands/newcmd.md` with frontmatter and instructions
2. Run `./install.sh` to create the symlink locally
3. Command becomes available as `/newcmd` globally

## Standup Configuration

On first `/standup` run in a project, you'll be prompted to configure:

- **Project name** - Display name for headers
- **Stack prefix** - CloudFormation stack filter (optional)
- **Pipeline name** - CodePipeline name (optional)
- **Frontend directories** - Paths to frontend apps

Configuration is saved to `.standup-config.json` in each project.
