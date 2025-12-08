# thecompany

Reusable Claude Code tooling distributed via global symlinks.

## Structure

- `commands/` - Slash command templates (symlinked to `~/.claude/commands/`)
- `scripts/` - Supporting scripts (symlinked to `~/.claude/scripts/`)
- `templates/` - Config templates for reference

## Installation

Run `./install.sh` once to create symlinks in `~/.claude/`. Changes to files here apply globally.

## Adding new commands

1. Create `commands/newcmd.md` with frontmatter and instructions
2. Add symlink in `install.sh`
3. Run `./install.sh` to update

## Conventions

- Commands reference scripts via `~/.claude/scripts/` (absolute path)
- Per-project config lives in each project's root (e.g., `.standup-config.json`)
- Commands should check for config and prompt user if missing
