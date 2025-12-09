---
description: Build and deploy MkDocs to AWS (password-protected hosting)
allowed-tools: ["Bash", "Read", "Write", "AskUserQuestion"]
---

Deploy the project's MkDocs documentation to AWS. Handles everything including first-time infrastructure setup.

## Step 1: Check for mkdocs.yml

```bash
test -f mkdocs.yml && echo "Found" || echo "Missing"
```

If missing, ask: "No mkdocs.yml found. Do you want me to initialize the docs structure first?"
- If yes, run `~/.claude/scripts/init-docs.sh .` equivalent steps
- If no, stop

## Step 2: Get Project Name

Try to extract from mkdocs.yml, stripping common suffixes:
```bash
grep -E "^site_name:" mkdocs.yml | sed 's/site_name: *//' | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed -E 's/-?docs?$//' | sed 's/-$//'
```

If empty or generic like "project", use AskUserQuestion to ask:
"What's the project name for the docs URL? (e.g., 'flashcards' → docs-flashcards.spacetimecards.com)"

The project name should be short and identify the project (e.g., "flashcards", "myapp"), NOT include "docs" in it.

## Step 3: Check if Infrastructure Exists

```bash
cat .docs-hosting.json 2>/dev/null || echo "{}"
```

If `.docs-hosting.json` exists with bucket and distributionId, skip to Step 6.

## Step 4: First-Time Setup - Get AWS Config

Check if SSM password exists:
```bash
aws ssm get-parameter --name "/thecompany/docs-password" --region us-east-1 2>/dev/null && echo "exists" || echo "missing"
```

If missing, use AskUserQuestion: "Enter a password for docs access (will be stored in AWS SSM):"
Then create it:
```bash
aws ssm put-parameter --name "/thecompany/docs-password" --value "THE_PASSWORD" --type SecureString --region us-east-1 --overwrite
```

Get Route53 hosted zone ID:
```bash
aws route53 list-hosted-zones --query "HostedZones[?Name=='spacetimecards.com.'].Id" --output text | sed 's|/hostedzone/||'
```

Get wildcard certificate ARN (must be in us-east-1):
```bash
aws acm list-certificates --region us-east-1 --query "CertificateSummaryList[?DomainName=='*.spacetimecards.com'].CertificateArn" --output text
```

If either is missing, use AskUserQuestion to get them from the user.

## Step 5: Deploy CDK Infrastructure

```bash
cd ~/dev/thecompany/cdk/docs-hosting && npm install --silent
```

Then deploy:
```bash
cd ~/dev/thecompany/cdk/docs-hosting && npx cdk deploy \
  -c projectName=PROJECT_NAME \
  -c hostedZoneId=ZONE_ID \
  -c certificateArn=CERT_ARN \
  --require-approval never \
  --outputs-file /tmp/cdk-outputs.json
```

Extract outputs and save to project:
```bash
cat /tmp/cdk-outputs.json
```

Create `.docs-hosting.json` in the project root with:
```json
{
  "bucket": "BUCKET_NAME_FROM_OUTPUT",
  "distributionId": "DISTRIBUTION_ID_FROM_OUTPUT",
  "url": "URL_FROM_OUTPUT"
}
```

Tell user: "Infrastructure deployed! Your docs will be at: https://docs-PROJECT.spacetimecards.com"

## Step 6: Build and Deploy Docs

```bash
mkdocs build
```

```bash
BUCKET=$(jq -r '.bucket' .docs-hosting.json)
aws s3 sync site/ "s3://$BUCKET" --delete
```

```bash
DIST_ID=$(jq -r '.distributionId' .docs-hosting.json)
aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "/*"
```

## Step 7: Report Success

Read the URL from .docs-hosting.json and tell the user:
- Docs deployed successfully
- URL: https://docs-PROJECT.spacetimecards.com
- Username: docs
- Password: (stored in AWS SSM)
