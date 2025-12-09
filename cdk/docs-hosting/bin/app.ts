#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { DocsHostingStack } from '../lib/docs-hosting-stack';

const app = new cdk.App();

// Get required context values
const projectName = app.node.tryGetContext('projectName');
const domainName = app.node.tryGetContext('domainName') || 'spacetimecards.com';
const hostedZoneId = app.node.tryGetContext('hostedZoneId');
const certificateArn = app.node.tryGetContext('certificateArn');
const ssmPasswordPath = app.node.tryGetContext('ssmPasswordPath') || '/thecompany/docs-password';
const subdomain = app.node.tryGetContext('subdomain'); // Optional custom subdomain

if (!projectName) {
  throw new Error('Missing required context: projectName (use -c projectName=myproject)');
}

if (!hostedZoneId) {
  throw new Error('Missing required context: hostedZoneId (use -c hostedZoneId=ZXXXXX)');
}

if (!certificateArn) {
  throw new Error('Missing required context: certificateArn (use -c certificateArn=arn:aws:acm:...)');
}

new DocsHostingStack(app, `DocsHosting-${projectName}`, {
  projectName,
  domainName,
  hostedZoneId,
  certificateArn,
  ssmPasswordPath,
  subdomain,
  env: {
    account: process.env.CDK_DEFAULT_ACCOUNT,
    region: 'us-east-1', // Lambda@Edge requires us-east-1
  },
  crossRegionReferences: true,
});
