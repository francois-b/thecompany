# Docs Hosting CDK Stack

Password-protected MkDocs hosting on AWS using S3 + CloudFront + Lambda@Edge.

## Prerequisites

1. **AWS CLI configured** with credentials
2. **CDK bootstrapped** in us-east-1:
   ```bash
   cdk bootstrap aws://ACCOUNT_ID/us-east-1
   ```
3. **Password in SSM Parameter Store**:
   ```bash
   aws ssm put-parameter \
     --name "/thecompany/docs-password" \
     --value "your-password-here" \
     --type SecureString \
     --region us-east-1
   ```
4. **Wildcard certificate** for *.spacetimecards.com in ACM (us-east-1)
5. **Route53 hosted zone** for spacetimecards.com

## Deploy

```bash
cd cdk/docs-hosting
npm install

# Deploy infrastructure for a project
cdk deploy \
  -c projectName=flashcards \
  -c hostedZoneId=ZXXXXXXXXXXXXX \
  -c certificateArn=arn:aws:acm:us-east-1:ACCOUNT:certificate/XXXXX
```

This creates:
- S3 bucket: `docs-flashcards-spacetimecards-com`
- CloudFront distribution with basic auth
- Route53 record: `docs-flashcards.spacetimecards.com`

## Upload Docs

After deploying infrastructure, upload your built docs:

```bash
# From your project directory
mkdocs build
aws s3 sync site/ s3://docs-PROJECT-spacetimecards-com --delete
aws cloudfront create-invalidation --distribution-id XXXXX --paths "/*"
```

Or use the deploy-docs.sh script from thecompany (see main README).

## Context Parameters

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `projectName` | Yes | - | Project name (used in subdomain) |
| `hostedZoneId` | Yes | - | Route53 hosted zone ID |
| `certificateArn` | Yes | - | Wildcard cert ARN in us-east-1 |
| `domainName` | No | spacetimecards.com | Base domain |
| `ssmPasswordPath` | No | /thecompany/docs-password | SSM path for password |

## Destroy

```bash
cdk destroy -c projectName=flashcards -c hostedZoneId=... -c certificateArn=...
```
