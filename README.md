[![](https://codebuild.ap-northeast-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiKzU5NHhnZXVnS1RPZk1mcTBXQ0lxWUt4R3lxVTV1NHZmcjEyMkFKTGc5cGMxSDhrZ0pmRHdVN1lvYkpUaEV4VjRxeWVJdW9SUmo3U09yckJjL3RjdTY4PSIsIml2UGFyYW1ldGVyU3BlYyI6ImxBaDRSN0hpaW9iZTlSbXgiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:903779448426:applications~lambda-layer-aws-sdk-js)
[![](https://img.shields.io/badge/Available-serverless%20app%20repository-blue.svg)](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:903779448426:applications~lambda-layer-aws-sdk-js)



# AWS Lambda Layer for aws-sdk-js and node runtime

This repo builds the latest `aws-sdk-js` as AWS Lambda Layer for node runtimew and publishes to [AWS SAR](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:903779448426:applications~lambda-layer-aws-sdk-js). We automate the daily build the publish to SAR with CodeBuild.


## CDK Sample

```js
    const samApp = new sam.CfnApplication(this, 'SamLayer', {
      location: {
        applicationId: 'arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-aws-sdk-js',
        semanticVersion: '2.578.0'
      },
      parameters: {
        LayerName: `${this.stackName}-AwsSdkJs-lambdaLayer`
      }
    })

    const layerVersionArn = samApp.getAtt('Outputs.LayerVersionArn').toString();

    const handler = new lambda.Function(this, 'Func', {
      code: lambda.AssetCode.fromInline(`
var AWS = require("aws-sdk");
exports.handler = async (event) => {
    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello AWS SDK JS VERSION:'+AWS.VERSION),
    };
    return response;
};
`),
      runtime: lambda.Runtime.NODEJS_8_10,
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
```
view full sample at [play-with-cdk](https://play-with-cdk.com?s=278aaa47f8dd9c5e16af72497748ace3)


