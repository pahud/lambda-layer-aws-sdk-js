[![](https://codebuild.ap-northeast-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiQkNQRDFNdksreTI4dFVEc2cxc3Fra3oyMmo4ODFjcElpc3J1OGowR3RXb2s1eVZXWURNbDVoTXRFbjR4TU5hN292NlFLV3pLV0RWZGlGRjVkUW9MRTEwPSIsIml2UGFyYW1ldGVyU3BlYyI6Ing5WmZqOCs1NnQzdCt5NSsiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:903779448426:applications~lambda-layer-botocore)
[![](https://img.shields.io/badge/Available-serverless%20app%20repository-blue.svg)](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:903779448426:applications~lambda-layer-botocore)






# AWS Lambda Layer for botocore with Python3

This repo builds the latest `botocore` with python3 into AWS Lambda Layer and publishes to [AWS SAR](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:903779448426:applications~lambda-layer-botocore). We automate the daily build the publish to SAR with CodeBuild.


## CDK Sample

or view it from [play-with-cdk](https://play-with-cdk.com?s=538e3d7fdd1edc1a8e8421dcdb70bd22)

```js
import * as cdk from '@aws-cdk/core';
import * as sam from '@aws-cdk/aws-sam';
import * as lambda from '@aws-cdk/aws-lambda';
import * as apigateway from '@aws-cdk/aws-apigateway';

export class AppStack extends cdk.Stack {
    constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
        super(scope, id, props);
    
    const samApp = new sam.CfnApplication(this, 'SamLayer', {
      location: {
        applicationId: 'arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-botocore',
        semanticVersion: '1.13.19'
      }
    })

    const layerVersionArn = samApp.getAtt('Outputs.LayerVersionArn').toString();

    const handler = new lambda.Function(this, 'Func', {
      code: lambda.AssetCode.fromInline(`
import botocore, json
def handler(event, context):
  return {
    'statusCode': 200,
    'body': json.dumps(botocore.__version__)
  }`),
      runtime: lambda.Runtime.PYTHON_3_7,
      handler: 'index.handler',
      layers: [
        lambda.LayerVersion.fromLayerVersionArn(this, 'Layer', layerVersionArn)
      ]
    })

    new apigateway.LambdaRestApi(this, 'Api', {
      handler
    })

    new cdk.CfnOutput(this, 'LayerVersionArn', {
      value: layerVersionArn
    })

    }
}
```
# aws-lambda-layer-aws-sdk-js
