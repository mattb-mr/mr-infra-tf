## Overview
Terraform builds a small AWS stack (VPC, public subnet, security group, EC2 instance) with an S3 backend. GitHub Actions runs fmt/validate/plan on pull requests and fmt/validate/plan/apply on pushes to `main`, posting the plan back to pull requests.

## Prerequisites
- S3 bucket for state with encryption enabled.
- DynamoDB table for state locking (optional but recommended).
- IAM user or role with access to the S3 bucket, DynamoDB table, and the AWS resources created by Terraform.
- GitHub Actions runner with access to those credentials.

## Required environment variables (GitHub Actions)
Add these in Repository Settings → Secrets and variables → Actions. Use Secrets for sensitive values and Variables for non-sensitive defaults.
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` (Secrets): AWS credentials used by Terraform.
- `AWS_REGION` (Secret): Region for AWS calls.
- `TF_STATE_BUCKET` (Secret): S3 bucket name for the backend.
- `TF_STATE_KEY` (Secret): Path within the bucket for the state file (for example `spacelift/ec2/terraform.tfstate`).
- `TF_STATE_REGION` (Secret): Region where the S3 bucket lives.
- `TF_STATE_DYNAMODB_TABLE` (Secret, optional): DynamoDB table name for state locking.
- `TF_VAR_instance_name` (Variable, optional): Tag base for created resources (default `spacelift-ec2`).
- `TF_VAR_instance_type` (Variable, optional): EC2 instance type (default `t3.micro`).
- `TF_VAR_key_name` (Variable, optional): Existing EC2 key pair name if SSH access is required.
- `TF_VAR_ssh_ingress_cidr` (Variable, optional): CIDR allowed to SSH into the instance (default `0.0.0.0/0`).
- `TF_VAR_availability_zone` (Variable, optional): Availability zone override.
- `TF_VAR_aws_region` (Variable, optional): Region override for the Terraform provider if different from `AWS_REGION`.

## Pipeline behavior
- Pull requests to `main`: fmt, validate, and plan run; plan output is posted as a PR comment.
- Pushes to `main`: fmt, validate, plan, and apply run; apply consumes the generated plan from the same run.

## Local usage
```sh
terraform init -backend-config="bucket=$TF_STATE_BUCKET" -backend-config="key=$TF_STATE_KEY" -backend-config="region=$TF_STATE_REGION" -backend-config="dynamodb_table=$TF_STATE_DYNAMODB_TABLE"
terraform plan
terraform apply
```
