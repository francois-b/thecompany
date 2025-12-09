#!/bin/bash
# Optional script to prompt for AWS credentials during SessionStart
# Only prompts if AWS is not already configured

# Check if AWS credentials are already available
if aws sts get-caller-identity &>/dev/null; then
  echo "✓ AWS credentials already configured"
  exit 0
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  AWS Credentials Setup (Optional)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "AWS credentials not detected. /standup will skip AWS infrastructure sections."
echo ""
echo "To enable AWS features (CloudFormation, CodePipeline, Cost Explorer),"
echo "enter your credentials below, or press Enter to skip."
echo ""

read -p "AWS_ACCESS_KEY_ID (or Enter to skip): " aws_key

# If user skipped, exit gracefully
if [ -z "$aws_key" ]; then
  echo ""
  echo "⊘ Skipping AWS configuration. /standup will work without AWS features."
  echo ""
  exit 0
fi

# Prompt for remaining credentials
read -sp "AWS_SECRET_ACCESS_KEY: " aws_secret
echo ""
read -p "AWS_DEFAULT_REGION [us-east-1]: " aws_region
aws_region=${aws_region:-us-east-1}

# Validate credentials are non-empty
if [ -z "$aws_secret" ]; then
  echo "⚠ AWS_SECRET_ACCESS_KEY cannot be empty. Skipping AWS setup."
  exit 0
fi

# Write to CLAUDE_ENV_FILE for persistence within the session
if [ -n "$CLAUDE_ENV_FILE" ]; then
  cat >> "$CLAUDE_ENV_FILE" << EOF
export AWS_ACCESS_KEY_ID=$aws_key
export AWS_SECRET_ACCESS_KEY=$aws_secret
export AWS_DEFAULT_REGION=$aws_region
EOF
  echo ""
  echo "✓ AWS credentials configured for this session"
  echo ""
else
  # Fallback: create ~/.aws/credentials (standard AWS location)
  mkdir -p ~/.aws
  cat > ~/.aws/credentials << EOF
[default]
aws_access_key_id = $aws_key
aws_secret_access_key = $aws_secret
EOF
  cat > ~/.aws/config << EOF
[default]
region = $aws_region
EOF
  echo ""
  echo "✓ AWS credentials saved to ~/.aws/credentials"
  echo ""
fi
