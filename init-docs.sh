#!/bin/bash
# Initialize docs structure in a project
# Usage: ~/dev/thecompany/init-docs.sh <project-path>

set -e

THECOMPANY_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="${1:-.}"

# Resolve to absolute path
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Directory does not exist: $TARGET_DIR" >&2
  exit 1
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo "Initializing docs structure in: $TARGET_DIR"
echo ""

# Create docs directories
FOLDERS="bugs design meetings operations research reviews todos"
for folder in $FOLDERS; do
  mkdir -p "$TARGET_DIR/docs/$folder"
done
echo "  ✓ Created docs folders: $FOLDERS"

# Symlink meta folder
ln -sfn "$THECOMPANY_DIR/docs-meta" "$TARGET_DIR/docs/meta"
echo "  ✓ Linked docs/meta/ → thecompany/docs-meta/"

# Symlink README files for each folder
for folder in $FOLDERS; do
  template="$THECOMPANY_DIR/docs-templates/${folder}-README.md"
  if [ -f "$template" ]; then
    ln -sf "$template" "$TARGET_DIR/docs/$folder/README.md"
    echo "  ✓ Linked docs/$folder/README.md"
  fi
done

# Copy docs/README.md template (not symlinked - project-specific)
if [ ! -f "$TARGET_DIR/docs/README.md" ]; then
  cp "$THECOMPANY_DIR/templates/docs-README.md" "$TARGET_DIR/docs/README.md"
  echo "  ✓ Created docs/README.md (edit to add your docs index)"
fi

# Symlink config files to project root
ln -sf "$THECOMPANY_DIR/configs/.markdownlint.jsonc" "$TARGET_DIR/.markdownlint.jsonc"
echo "  ✓ Linked .markdownlint.jsonc"

ln -sf "$THECOMPANY_DIR/configs/.vale.ini" "$TARGET_DIR/.vale.ini"
echo "  ✓ Linked .vale.ini"

ln -sf "$THECOMPANY_DIR/configs/.markdown-link-check.json" "$TARGET_DIR/.markdown-link-check.json"
echo "  ✓ Linked .markdown-link-check.json"

# Copy mkdocs.yml template (not symlinked - project-specific)
if [ ! -f "$TARGET_DIR/mkdocs.yml" ]; then
  cp "$THECOMPANY_DIR/templates/mkdocs.yml" "$TARGET_DIR/mkdocs.yml"
  echo "  ✓ Created mkdocs.yml (edit site_name for your project)"
fi

echo ""
echo "Done! Docs structure initialized."
echo ""
echo "Next steps:"
echo "  1. Edit docs/README.md to add your project's doc index"
echo "  2. Edit mkdocs.yml to set your project name"
echo "  3. Use /new-design-doc, /new-bug, /new-todo, /new-research to create docs"
echo ""
echo "To check symlink health later, run:"
echo "  $THECOMPANY_DIR/setup-doctor.sh $TARGET_DIR"
