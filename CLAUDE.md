# thecompany

Reusable Claude Code tooling for standups and infrastructure monitoring.

Works with both Claude Code desktop/CLI and Claude Code on the web.

## Structure

- `.claude/commands/` - Slash commands (auto-loaded on web, symlinked locally)
- `.claude/scripts/` - Supporting scripts
- `templates/` - Config templates for reference
- `commands/`, `scripts/` - Legacy directories (deprecated)

## Installation

**Web:** No installation needed - commands in `.claude/` are auto-loaded.

**Local:** Run `./install.sh` once to create symlinks in `~/.claude/`.

## Adding new commands

1. Create `.claude/commands/newcmd.md` with frontmatter and instructions
2. Reference scripts via `./.claude/scripts/` (repo-relative path)
3. Update `install.sh` if you want it available globally on local CLI
4. Commands should check for per-project config (e.g., `.standup-config.json`)

## Conventions

- Commands reference scripts via `./.claude/scripts/` (repo-relative, works on web)
- Per-project config lives in each project's root
- Scripts should work in isolated web VMs (no home directory access)
