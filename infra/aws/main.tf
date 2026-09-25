terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # backend "s3" {}  # enable for shared state
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      project = "sijainen"
      env     = var.env
    }
  }
}

# TODO: webhook      - aws_apigatewayv2_api + aws_lambda_function
# TODO: queue        - aws_sqs_queue (transcript chunks)
# TODO: detector     - aws_lambda_function (SQS trigger)
# TODO: state        - aws_dynamodb_table (meetings, events)
# TODO: secrets      - aws_secretsmanager_secret (bot vendor + LLM keys)
# TODO: push         - aws_sns_platform_application (FCM / APNs)
