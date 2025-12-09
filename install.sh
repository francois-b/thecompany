#!/bin/bash
# Setup global Claude Code commands (run once)
# Usage: ~/dev/thecompany/install.sh

set -e

THECOMPANY_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing thecompany tooling globally..."

# Create global directories
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/scripts

# Symlink commands
ln -sf "$THECOMPANY_DIR/.claude/commands/standup.md" ~/.claude/commands/standup.md
echo "  ✓ Linked ~/.claude/commands/standup.md"

# Symlink scripts
ln -sf "$THECOMPANY_DIR/.claude/scripts/standup-data.sh" ~/.claude/scripts/standup-data.sh
echo "  ✓ Linked ~/.claude/scripts/standup-data.sh"

echo ""
echo "Done! /standup is now available in all projects."
echo "Edit files in $THECOMPANY_DIR to update globally."
