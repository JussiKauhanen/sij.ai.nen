# infra/aws

Terraform skeleton. Region: `eu-north-1` (Stockholm), closest AWS region to Finland.

Planned resources: API Gateway + Lambda (webhook), SQS (transcript queue), Lambda or ECS Fargate (detector), Lambda (drafter), Bedrock (LLM) + Bedrock Knowledge Bases or OpenSearch Serverless (search index for drafts), DynamoDB (state + approval audit log), Secrets Manager (API keys), SNS (push).

```bash
cd infra/aws
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
```

Use a remote state backend (S3 + DynamoDB lock) before sharing with others.
