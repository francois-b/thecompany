#!/bin/bash
# Gather standup data for /standup slash command
# Reads configuration from .standup-config.json in project root

set -e

CONFIG_FILE=".standup-config.json"

# Check if AWS credentials are available
AWS_AVAILABLE=false
if aws sts get-caller-identity &>/dev/null; then
  AWS_AVAILABLE=true
fi

# Read config values (with defaults)
if [ -f "$CONFIG_FILE" ]; then
  PROJECT_NAME=$(jq -r '.project_name // ""' "$CONFIG_FILE")
  STACK_PREFIX=$(jq -r '.stack_prefix // ""' "$CONFIG_FILE")
  PIPELINE_NAME=$(jq -r '.pipeline_name // ""' "$CONFIG_FILE")
  TODOS_PATH=$(jq -r '.todos_path // "docs/todos"' "$CONFIG_FILE")
  DESIGN_DOCS_PATH=$(jq -r '.design_docs_path // "docs/design"' "$CONFIG_FILE")
  ANDROID_APK_PATH=$(jq -r '.mobile.android_apk_path // ""' "$CONFIG_FILE")
  IOS_APP_PATH=$(jq -r '.mobile.ios_app_path // ""' "$CONFIG_FILE")
  FRONTENDS=$(jq -r '.frontends // []' "$CONFIG_FILE")
else
  PROJECT_NAME=""
  STACK_PREFIX=""
  PIPELINE_NAME=""
  TODOS_PATH="docs/todos"
  DESIGN_DOCS_PATH="docs/design"
  ANDROID_APK_PATH=""
  IOS_APP_PATH=""
  FRONTENDS="[]"
fi

echo "=== CONFIG ==="
echo "PROJECT_NAME=$PROJECT_NAME"
echo "STACK_PREFIX=$STACK_PREFIX"
echo "PIPELINE_NAME=$PIPELINE_NAME"

echo "=== STACKS ==="
if [ "$AWS_AVAILABLE" = true ] && [ -n "$STACK_PREFIX" ]; then
  aws cloudformation describe-stacks --query "Stacks[?contains(StackName, \`$STACK_PREFIX\`)].{Name:StackName,Status:StackStatus,Updated:LastUpdatedTime}" --output json 2>/dev/null || echo "[]"
else
  echo "[]"
fi

echo "=== PIPELINE ==="
if [ "$AWS_AVAILABLE" = true ] && [ -n "$PIPELINE_NAME" ]; then
  aws codepipeline get-pipeline-state --name "$PIPELINE_NAME" --query 'stageStates[*].{Stage:stageName,Status:latestExecution.status}' --output json 2>/dev/null || echo "[]"
else
  echo "[]"
fi

echo "=== COSTS ==="
if [ "$AWS_AVAILABLE" = true ]; then
  START=$(date -v1d +%Y-%m-01 2>/dev/null || date -d "$(date +%Y-%m-01)" +%Y-%m-01)
  END=$(date +%Y-%m-%d)
  aws ce get-cost-and-usage --time-period Start=$START,End=$END --granularity MONTHLY --metrics "UnblendedCost" --group-by Type=DIMENSION,Key=SERVICE --output json 2>/dev/null || echo "{}"
else
  echo "{}"
fi

echo "=== GIT_LOG ==="
git log --oneline -20 --format="%h %s" 2>/dev/null || echo "No git history"

echo "=== TODOS ==="
if [ -d "$TODOS_PATH" ]; then
  for f in "$TODOS_PATH"/TODO-*.md; do
    if [ -f "$f" ]; then
      status=$(grep -A1 "^## Status" "$f" 2>/dev/null | tail -1 | tr -d "\r")
      title=$(head -1 "$f" | sed "s/^# //")
      echo "$(basename "$f" .md)|$status|$title"
    fi
  done
else
  echo "No TODOs directory"
fi

echo "=== DESIGN_DOCS ==="
if [ -d "$DESIGN_DOCS_PATH" ]; then
  for f in "$DESIGN_DOCS_PATH"/DES-*.md; do
    if [ -f "$f" ]; then
      status=$(grep "^status:" "$f" 2>/dev/null | head -1 | cut -d: -f2 | tr -d " \r")
      title=$(grep "^title:" "$f" 2>/dev/null | head -1 | cut -d: -f2- | sed "s/^ *//")
      id=$(basename "$f" .md | cut -d- -f1,2)
      echo "$id|$status|$title"
    fi
  done
else
  echo "No Design Docs directory"
fi

echo "=== ANDROID_BUILD ==="
if [ -n "$ANDROID_APK_PATH" ] && [ -d "$ANDROID_APK_PATH" ]; then
  ls -la "$ANDROID_APK_PATH"/*.apk 2>/dev/null | head -1 || echo "No Android build found"
else
  echo "No Android path configured"
fi

echo "=== ANDROID_COMMITS ==="
if [ -d "android" ]; then
  git log --oneline -3 --format="%h %s" -- android/ 2>/dev/null || echo "No commits"
else
  echo "No Android directory"
fi

echo "=== IOS_BUILD ==="
if [ -n "$IOS_APP_PATH" ] && [ -d "$IOS_APP_PATH" ]; then
  ls -la "$IOS_APP_PATH"/*.app 2>/dev/null | head -1 || echo "No iOS build found"
else
  echo "No iOS path configured"
fi

echo "=== IOS_COMMITS ==="
if [ -d "ios" ]; then
  git log --oneline -3 --format="%h %s" -- ios/ 2>/dev/null || echo "No commits"
else
  echo "No iOS directory"
fi

echo "=== FRONTENDS ==="
# Output frontend paths from config for the command to process
echo "$FRONTENDS"

echo "=== FRONTEND_COMMITS ==="
# Get commits for each frontend directory
echo "$FRONTENDS" | jq -r '.[]' 2>/dev/null | while read -r frontend; do
  if [ -n "$frontend" ] && [ -d "$frontend" ]; then
    echo "--- $frontend ---"
    git log --oneline -3 --format="%h %s" -- "$frontend/" 2>/dev/null || echo "No commits"
  fi
done

echo "=== END ==="
