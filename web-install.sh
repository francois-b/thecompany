#!/bin/bash
# Web installation script for Claude Code on the web
# Clones thecompany and theteam repos and sets up ~/.claude/ symlinks

set -e

echo "Installing Claude Code extensions for web..."

# Clone repos if they don't exist
if [ ! -d ~/.thecompany ]; then
  echo "  Cloning thecompany..."
  git clone https://github.com/francois-b/thecompany ~/.thecompany
else
  echo "  ✓ thecompany already cloned"
fi

if [ ! -d ~/.theteam ]; then
  echo "  Cloning theteam..."
  git clone https://github.com/francois-b/theteam ~/.theteam
else
  echo "  ✓ theteam already cloned"
fi

# Create global directories
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/scripts

# Symlink thecompany commands and scripts
echo "  Linking thecompany commands..."
if [ -d ~/.thecompany/.claude/commands ]; then
  for cmd in ~/.thecompany/.claude/commands/*.md; do
    [ -f "$cmd" ] && ln -sf "$cmd" ~/.claude/commands/
  done
fi

if [ -d ~/.thecompany/.claude/scripts ]; then
  for script in ~/.thecompany/.claude/scripts/*; do
    [ -f "$script" ] && ln -sf "$script" ~/.claude/scripts/
  done
fi

# Symlink theteam commands and scripts
echo "  Linking theteam commands..."
if [ -d ~/.theteam/.claude/commands ]; then
  for cmd in ~/.theteam/.claude/commands/*.md; do
    [ -f "$cmd" ] && ln -sf "$cmd" ~/.claude/commands/
  done
fi

if [ -d ~/.theteam/.claude/scripts ]; then
  for script in ~/.theteam/.claude/scripts/*; do
    [ -f "$script" ] && ln -sf "$script" ~/.claude/scripts/
  done
fi

echo ""
echo "✓ Installation complete!"
echo "  Commands from thecompany and theteam are now available."
echo ""
