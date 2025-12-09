# thecompany

Reusable Claude Code tooling for standups and infrastructure monitoring.

Works with both Claude Code desktop/CLI and Claude Code on the web.

## Structure

- `.claude/commands/` - Slash commands (auto-loaded on web, symlinked locally)
- `.claude/scripts/` - Supporting scripts
- `templates/` - Config templates for reference
- `commands/`, `scripts/` - Legacy directories (deprecated)

## Installation

**Web:** Add SessionStart hook to your project's `.claude/settings.json` (see README.md).

**Local:** Run `./install.sh` once to create symlinks in `~/.claude/`.

## Adding new commands

1. Create `.claude/commands/newcmd.md` with frontmatter and instructions
2. Reference scripts via `~/.claude/scripts/` (absolute path via symlinks)
3. Update `install.sh` to symlink new commands locally
4. Commands should check for per-project config (e.g., `.standup-config.json`)

## Conventions

- Commands reference scripts via `~/.claude/scripts/` (works on both web and local)
- Per-project config lives in each project's root (not in thecompany repo)
- Scripts should work in isolated web VMs (no persistent home directory)
- Web sessions use `web-install.sh` via SessionStart hook to recreate `~/.claude/`
