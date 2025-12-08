#!/bin/bash
# Install thecompany tooling into a project
# Usage: ~/dev/thecompany/install.sh [target-dir]

set -e

THECOMPANY_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="${1:-.}"

# Resolve to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo "Installing thecompany tooling into: $TARGET_DIR"

# Create directories
mkdir -p "$TARGET_DIR/.claude/commands"
mkdir -p "$TARGET_DIR/scripts"

# Copy commands
cp "$THECOMPANY_DIR/commands/standup.md" "$TARGET_DIR/.claude/commands/"
echo "  ✓ Copied .claude/commands/standup.md"

# Copy scripts
cp "$THECOMPANY_DIR/scripts/standup-data.sh" "$TARGET_DIR/scripts/"
chmod +x "$TARGET_DIR/scripts/standup-data.sh"
echo "  ✓ Copied scripts/standup-data.sh"

# Create config template if it doesn't exist
if [ ! -f "$TARGET_DIR/.standup-config.json" ]; then
  cp "$THECOMPANY_DIR/templates/standup-config.json" "$TARGET_DIR/.standup-config.json"
  echo "  ✓ Created .standup-config.json (edit or delete to re-prompt)"
fi

echo ""
echo "Done! Run /standup in Claude Code to get started."
echo "On first run, you'll be prompted to configure project-specific settings."
