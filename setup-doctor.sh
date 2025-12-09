#!/bin/bash
# Health check and fix for thecompany symlinks
# Usage: ~/dev/thecompany/setup-doctor.sh [project-path ...]
#
# Checks:
#   - Global symlinks in ~/.claude/commands/ and ~/.claude/scripts/
#   - Per-project symlinks in docs/ and config files
#
# Fixes broken symlinks by re-creating them pointing to current thecompany location

set -e

THECOMPANY_DIR="$(cd "$(dirname "$0")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

ISSUES=0
FIXED=0

check_symlink() {
  local link="$1"
  local expected_target="$2"
  local description="$3"

  if [ ! -L "$link" ]; then
    echo -e "  ${RED}✗${NC} $description: not a symlink"
    ((ISSUES++))
    return 1
  fi

  if [ ! -e "$link" ]; then
    echo -e "  ${RED}✗${NC} $description: broken symlink"
    ((ISSUES++))
    return 1
  fi

  local actual_target
  actual_target=$(readlink "$link")
  if [ "$actual_target" != "$expected_target" ]; then
    echo -e "  ${YELLOW}!${NC} $description: points to wrong target"
    echo "      Expected: $expected_target"
    echo "      Actual:   $actual_target"
    ((ISSUES++))
    return 1
  fi

  echo -e "  ${GREEN}✓${NC} $description"
  return 0
}

fix_symlink() {
  local link="$1"
  local target="$2"

  rm -f "$link"
  ln -sf "$target" "$link"
  ((FIXED++))
  echo -e "      ${GREEN}Fixed${NC}"
}

echo "thecompany setup-doctor"
echo "======================="
echo "thecompany location: $THECOMPANY_DIR"
echo ""

# Check global symlinks
echo "Checking global symlinks..."

# Commands
for cmd in "$THECOMPANY_DIR"/.claude/commands/*.md; do
  name=$(basename "$cmd")
  link="$HOME/.claude/commands/$name"
  if ! check_symlink "$link" "$cmd" "~/.claude/commands/$name"; then
    read -p "      Fix? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      mkdir -p "$HOME/.claude/commands"
      fix_symlink "$link" "$cmd"
    fi
  fi
done

# Scripts
for script in "$THECOMPANY_DIR"/.claude/scripts/*.sh; do
  name=$(basename "$script")
  link="$HOME/.claude/scripts/$name"
  if ! check_symlink "$link" "$script" "~/.claude/scripts/$name"; then
    read -p "      Fix? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      mkdir -p "$HOME/.claude/scripts"
      fix_symlink "$link" "$script"
    fi
  fi
done

# Check per-project symlinks if paths provided
if [ $# -gt 0 ]; then
  for project in "$@"; do
    if [ ! -d "$project" ]; then
      echo ""
      echo -e "${RED}Project not found: $project${NC}"
      continue
    fi

    project=$(cd "$project" && pwd)
    echo ""
    echo "Checking project: $project"

    # Check docs/meta symlink
    link="$project/docs/meta"
    target="$THECOMPANY_DIR/docs-meta"
    if [ -d "$project/docs" ]; then
      if ! check_symlink "$link" "$target" "docs/meta/"; then
        read -p "      Fix? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          fix_symlink "$link" "$target"
        fi
      fi
    fi

    # Check folder README symlinks
    for folder in bugs design meetings operations research reviews todos; do
      link="$project/docs/$folder/README.md"
      target="$THECOMPANY_DIR/docs-templates/${folder}-README.md"
      if [ -d "$project/docs/$folder" ]; then
        if ! check_symlink "$link" "$target" "docs/$folder/README.md"; then
          read -p "      Fix? [y/N] " -n 1 -r
          echo
          if [[ $REPLY =~ ^[Yy]$ ]]; then
            fix_symlink "$link" "$target"
          fi
        fi
      fi
    done

    # Check config symlinks
    for config in .markdownlint.jsonc .vale.ini .markdown-link-check.json; do
      link="$project/$config"
      target="$THECOMPANY_DIR/configs/$config"
      if ! check_symlink "$link" "$target" "$config"; then
        read -p "      Fix? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          fix_symlink "$link" "$target"
        fi
      fi
    done
  done
fi

echo ""
echo "======================="
if [ $ISSUES -eq 0 ]; then
  echo -e "${GREEN}All symlinks healthy!${NC}"
else
  echo -e "Issues found: $ISSUES"
  echo -e "Issues fixed: $FIXED"
  if [ $((ISSUES - FIXED)) -gt 0 ]; then
    echo -e "${YELLOW}Remaining issues: $((ISSUES - FIXED))${NC}"
  fi
fi
