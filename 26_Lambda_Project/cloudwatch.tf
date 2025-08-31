# =============================================================================
# CLOUDWATCH LOGS CONFIGURATION
# =============================================================================
# This file manages CloudWatch Log Groups for Lambda function logging.
# It includes an import block to manage existing log groups that were
# created outside of Terraform, bringing them under Terraform management.

# Import block to bring existing CloudWatch Log Group under Terraform management
# This is used when a log group was created manually or by AWS services
# and you want to manage it with Terraform going forward
import {
  # The Terraform resource that will manage the imported resource
  to = aws_cloudwatch_log_group.lambda

  # The actual AWS resource identifier (log group name)
  # This must match the existing log group name in AWS
  id = "/aws/lambda/manually-created-lambda"
}

# CloudWatch Log Group for Lambda function logs
# Lambda functions automatically create log groups, but managing them
# explicitly provides better control over retention, permissions, and lifecycle
resource "aws_cloudwatch_log_group" "lambda" {
  # Log group name following AWS Lambda naming convention
  # Format: /aws/lambda/{function-name}
  # This naming pattern is automatically used by Lambda service
  name = "/aws/lambda/manually-created-lambda"

  # AWS region where the log group will be created
  # Must match the region where the Lambda function is deployed
  # Note: This parameter is deprecated in newer AWS provider versions
  # The provider region configuration is typically used instead
  region = "us-west-1"

  # Additional configurations that can be added:
  # retention_in_days = 14        # Log retention period (default: never expire)
  # kms_key_id       = "..."      # KMS key for log encryption
  # tags = {                      # Resource tags for organization
  #   Environment = "production"
  #   Purpose     = "lambda-logs"
  # }
}
