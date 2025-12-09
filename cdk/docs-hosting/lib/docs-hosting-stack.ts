import * as cdk from 'aws-cdk-lib';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';
import * as origins from 'aws-cdk-lib/aws-cloudfront-origins';
import * as route53 from 'aws-cdk-lib/aws-route53';
import * as targets from 'aws-cdk-lib/aws-route53-targets';
import * as acm from 'aws-cdk-lib/aws-certificatemanager';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as ssm from 'aws-cdk-lib/aws-ssm';
import * as fs from 'fs';
import * as path from 'path';
import { Construct } from 'constructs';

export interface DocsHostingStackProps extends cdk.StackProps {
  projectName: string;
  domainName: string; // e.g., spacetimecards.com
  hostedZoneId: string;
  certificateArn: string; // Wildcard cert ARN
  ssmPasswordPath: string; // e.g., /thecompany/docs-password
  ssmUsernamePath?: string; // Optional, defaults to 'docs'
}

export class DocsHostingStack extends cdk.Stack {
  public readonly bucketName: string;
  public readonly distributionId: string;
  public readonly docsUrl: string;

  constructor(scope: Construct, id: string, props: DocsHostingStackProps) {
    super(scope, id, props);

    const subdomain = `docs-${props.projectName}`;
    const fullDomain = `${subdomain}.${props.domainName}`;

    // S3 bucket for docs
    const bucket = new s3.Bucket(this, 'DocsBucket', {
      bucketName: `${subdomain}-${props.domainName.replace(/\./g, '-')}`,
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
      autoDeleteObjects: true,
    });

    // Get password from SSM (must exist before deploy)
    const password = ssm.StringParameter.valueForStringParameter(
      this,
      props.ssmPasswordPath
    );

    const username = props.ssmUsernamePath
      ? ssm.StringParameter.valueForStringParameter(this, props.ssmUsernamePath)
      : 'docs';

    // Read and inject credentials into Lambda code
    const lambdaCode = fs.readFileSync(
      path.join(__dirname, '../lambda/basic-auth.js'),
      'utf-8'
    )
      .replace('{{USERNAME}}', username)
      .replace('{{PASSWORD}}', password);

    // Lambda@Edge for basic auth (must be in us-east-1)
    const authFunction = new cloudfront.experimental.EdgeFunction(this, 'AuthFunction', {
      runtime: lambda.Runtime.NODEJS_20_X,
      handler: 'index.handler',
      code: lambda.Code.fromInline(lambdaCode),
      description: `Basic auth for ${fullDomain}`,
    });

    // Import existing certificate
    const certificate = acm.Certificate.fromCertificateArn(
      this,
      'Certificate',
      props.certificateArn
    );

    // CloudFront distribution
    const distribution = new cloudfront.Distribution(this, 'Distribution', {
      defaultBehavior: {
        origin: origins.S3BucketOrigin.withOriginAccessControl(bucket),
        viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
        edgeLambdas: [
          {
            functionVersion: authFunction.currentVersion,
            eventType: cloudfront.LambdaEdgeEventType.VIEWER_REQUEST,
          },
        ],
      },
      domainNames: [fullDomain],
      certificate,
      defaultRootObject: 'index.html',
      errorResponses: [
        {
          httpStatus: 404,
          responseHttpStatus: 200,
          responsePagePath: '/404.html',
          ttl: cdk.Duration.seconds(0),
        },
      ],
    });

    // Route53 record
    const hostedZone = route53.HostedZone.fromHostedZoneAttributes(this, 'HostedZone', {
      hostedZoneId: props.hostedZoneId,
      zoneName: props.domainName,
    });

    new route53.ARecord(this, 'AliasRecord', {
      zone: hostedZone,
      recordName: subdomain,
      target: route53.RecordTarget.fromAlias(new targets.CloudFrontTarget(distribution)),
    });

    // Outputs
    this.bucketName = bucket.bucketName;
    this.distributionId = distribution.distributionId;
    this.docsUrl = `https://${fullDomain}`;

    new cdk.CfnOutput(this, 'BucketName', { value: bucket.bucketName });
    new cdk.CfnOutput(this, 'DistributionId', { value: distribution.distributionId });
    new cdk.CfnOutput(this, 'DocsUrl', { value: `https://${fullDomain}` });
  }
}
