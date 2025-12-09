#!/bin/bash
# Build and deploy MkDocs to AWS
# Usage: deploy-docs.sh [project-path]
#
# Reads .docs-hosting.json from project root for bucket/distribution config
# Falls back to environment variables: DOCS_BUCKET, DOCS_DISTRIBUTION_ID

set -e

PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo "Deploying docs from: $PROJECT_DIR"

# Check for mkdocs.yml
if [ ! -f "$PROJECT_DIR/mkdocs.yml" ]; then
  echo -e "${RED}Error: mkdocs.yml not found in $PROJECT_DIR${NC}"
  exit 1
fi

# Load config from .docs-hosting.json or environment
CONFIG_FILE="$PROJECT_DIR/.docs-hosting.json"
if [ -f "$CONFIG_FILE" ]; then
  BUCKET=$(jq -r '.bucket // empty' "$CONFIG_FILE")
  DISTRIBUTION_ID=$(jq -r '.distributionId // empty' "$CONFIG_FILE")
  echo "  Using config from .docs-hosting.json"
else
  BUCKET="${DOCS_BUCKET:-}"
  DISTRIBUTION_ID="${DOCS_DISTRIBUTION_ID:-}"
  if [ -n "$BUCKET" ]; then
    echo "  Using config from environment variables"
  fi
fi

if [ -z "$BUCKET" ]; then
  echo -e "${RED}Error: No bucket configured${NC}"
  echo ""
  echo "Create .docs-hosting.json in your project root:"
  echo '  {"bucket": "docs-PROJECT-spacetimecards-com", "distributionId": "EXXXXX"}'
  echo ""
  echo "Or set environment variables:"
  echo "  export DOCS_BUCKET=docs-PROJECT-spacetimecards-com"
  echo "  export DOCS_DISTRIBUTION_ID=EXXXXX"
  exit 1
fi

# Build docs
echo ""
echo "Building docs..."
cd "$PROJECT_DIR"
mkdocs build

# Sync to S3
echo ""
echo "Uploading to S3..."
aws s3 sync site/ "s3://$BUCKET" --delete
echo -e "  ${GREEN}✓${NC} Uploaded to s3://$BUCKET"

# Invalidate CloudFront cache
if [ -n "$DISTRIBUTION_ID" ]; then
  echo ""
  echo "Invalidating CloudFront cache..."
  INVALIDATION_ID=$(aws cloudfront create-invalidation \
    --distribution-id "$DISTRIBUTION_ID" \
    --paths "/*" \
    --query 'Invalidation.Id' \
    --output text)
  echo -e "  ${GREEN}✓${NC} Invalidation created: $INVALIDATION_ID"
else
  echo -e "${YELLOW}Warning: No distributionId configured, skipping cache invalidation${NC}"
fi

echo ""
echo -e "${GREEN}Done!${NC}"
