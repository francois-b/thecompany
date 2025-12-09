---
description: Build and deploy MkDocs to AWS (password-protected hosting)
allowed-tools: ["Bash", "Read", "Write", "AskUserQuestion"]
---

Deploy the project's MkDocs documentation to AWS.

## Step 1: Check Prerequisites

Check if `.docs-hosting.json` exists in the project root:

```bash
cat .docs-hosting.json 2>/dev/null || echo "{}"
```

If it doesn't exist or is empty, tell the user:

"No `.docs-hosting.json` found. To set up docs hosting:

1. Deploy infrastructure (one-time):
   ```bash
   cd ~/dev/thecompany/cdk/docs-hosting
   npm install
   cdk deploy -c projectName=YOUR_PROJECT -c hostedZoneId=ZXXXXX -c certificateArn=arn:...
   ```

2. Create `.docs-hosting.json` with the outputs:
   ```json
   {\"bucket\": \"docs-PROJECT-spacetimecards-com\", \"distributionId\": \"EXXXXX\"}
   ```

3. Run `/deploy-docs` again"

Then stop.

## Step 2: Check for mkdocs.yml

```bash
test -f mkdocs.yml && echo "Found" || echo "Missing"
```

If missing, tell the user to run `init-docs.sh` first.

## Step 3: Deploy

Run the deploy script:

```bash
~/.claude/scripts/deploy-docs.sh .
```

## Step 4: Report Success

Tell the user:
- The docs URL (from .docs-hosting.json or infer from bucket name)
- Username is `docs`
- Password is stored in SSM at `/thecompany/docs-password`
