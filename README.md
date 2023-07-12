# Puppeteer-Bot

This project contains source code and supporting files for a serverless application that can be deployed with the AWS Serverless Application Model Command Line Interface (SAM CLI).


## To execute on local machine

1. Make sure you have NodeJS installed along with TypeScript. If not, install NodeJS from [here](https://nodejs.org/en/download/) and TypeScript from [here](https://www.typescriptlang.org/download).
2. Once above are installed, clone the project to your directory.
3. Run the command `npm install` (this is will install all the required dependent resources)
4. Run `npm run local` will execute the script.

## Deployment

### Prerequisites

To use the SAM CLI, the following tools must be installed:

- Docker - [Install Docker community edition](https://hub.docker.com/search/?type=edition&offering=community)
- AWS CLI - [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- SAM CLI - [Install the SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)

### Build

```sh
sam build
```

### Package

```sh
> export ECR_REPO="592678693542.dkr.ecr.ap-south-1.amazonaws.com/puppeteer-test"
```
```sh
> aws ecr get-login-password | docker login --username AWS --password-stdin "$ECR_REPO"
```
```sh
> sam package \
  --template-file .aws-sam/build/template.yaml \
  --output-template-file .aws-sam/build/packaged.yaml \
  --image-repository "$ECR_REPO"
```

### Deploy

```sh
> export STACK_NAME="puppeteer-bot"
```
```sh
> sam deploy \
   --template-file .aws-sam/build/packaged.yaml \
   --stack-name "$STACK_NAME" \
   --image-repository "$ECR_REPO" \
   --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND
```

## Cleanup

To delete the application, you can use the AWS CLI:

```sh
> aws cloudformation delete-stack --stack-name "$STACK_NAME"
```
