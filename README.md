## Overview
Terraform builds a small AWS stack (VPC, public subnet, security group, EC2 instance) with an S3 backend. GitHub Actions runs fmt/validate/plan on pull requests and fmt/validate/plan/apply on pushes to `main`, posting the plan back to pull requests.

## Prerequisites
- S3 bucket for state with encryption enabled.
- DynamoDB table for state locking (optional but recommended).
- IAM user or role with access to the S3 bucket, DynamoDB table, and the AWS resources created by Terraform.
- GitHub Actions runner with access to those credentials.

## Required environment variables (GitHub Actions)
Add these in Repository Settings → Secrets and variables → Actions.
- Secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` (use Secrets for any sensitive values; `AWS_REGION` can be a Secret if you prefer)
- Variables: `AWS_REGION`, `TF_STATE_BUCKET`, `TF_STATE_KEY`, `TF_STATE_REGION`, `TF_STATE_DYNAMODB_TABLE` (optional), `TF_VAR_instance_name`, `TF_VAR_instance_type`, `TF_VAR_key_name` (optional), `TF_VAR_ssh_ingress_cidr`, `TF_VAR_availability_zone`, `TF_VAR_aws_region`.

## Pipeline behavior
- Pull requests to `main`: fmt, validate, and plan run; plan output is posted as a PR comment.
- Pushes to `main`: fmt, validate, plan, and apply run; apply consumes the generated plan from the same run.

## Local usage
```sh
terraform init -backend-config="bucket=$TF_STATE_BUCKET" -backend-config="key=$TF_STATE_KEY" -backend-config="region=$TF_STATE_REGION" -backend-config="dynamodb_table=$TF_STATE_DYNAMODB_TABLE"
terraform plan
terraform apply
```
