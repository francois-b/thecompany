#!/bin/bash
# Setup global Claude Code commands and scripts (run once)
# Usage: ~/dev/thecompany/install.sh

set -e

THECOMPANY_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing thecompany tooling globally..."

# Create global directories
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/scripts

# Symlink commands (from .claude/commands/)
for cmd in "$THECOMPANY_DIR"/.claude/commands/*.md; do
  name=$(basename "$cmd")
  ln -sf "$cmd" ~/.claude/commands/"$name"
  echo "  ✓ Linked ~/.claude/commands/$name"
done

# Symlink scripts (from .claude/scripts/)
for script in "$THECOMPANY_DIR"/.claude/scripts/*.sh; do
  name=$(basename "$script")
  ln -sf "$script" ~/.claude/scripts/"$name"
  chmod +x "$script"
  echo "  ✓ Linked ~/.claude/scripts/$name"
done

echo ""
echo "Done! Global commands installed:"
echo "  /standup        - Project standup with AWS status"
echo "  /new-design-doc - Create a new design document"
echo "  /new-bug        - Create a new bug report"
echo "  /new-todo       - Create a new TODO item"
echo "  /new-research   - Create a new research document"
echo ""
echo "Edit files in $THECOMPANY_DIR to update globally."
echo ""
echo "To set up docs structure in a project, run:"
echo "  $THECOMPANY_DIR/init-docs.sh <project-path>"
