# =============================================================================
# IAM CONFIGURATION FOR LAMBDA FUNCTION
# =============================================================================
# This file defines the IAM roles, policies, and permissions required for
# AWS Lambda function execution. It implements the principle of least privilege
# by granting only the necessary permissions for Lambda execution and logging.

# Data source to get current AWS account information
# Used to construct ARNs and for account-specific configurations
data "aws_caller_identity" "current" {}

# Data source to get current AWS region information
# Used to construct region-specific ARNs for CloudWatch Logs
data "aws_region" "current" {}

# IAM policy document for Lambda service assume role
# This policy allows the AWS Lambda service to assume the execution role
# Required for Lambda to execute functions on behalf of the role
data "aws_iam_policy_document" "assume_lambda_execution_role" {
  statement {
    sid    = ""      # Statement ID (optional)
    effect = "Allow" # Allow the specified actions

    # The STS AssumeRole action allows the Lambda service to assume this role
    actions = ["sts:AssumeRole"]

    # Define which AWS service can assume this role
    principals {
      type = "Service" # AWS service principal
      # Only the Lambda service can assume this role
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# IAM policy document defining Lambda execution permissions
# This policy grants the Lambda function necessary permissions for:
# - Creating CloudWatch Log Groups
# - Creating CloudWatch Log Streams
# - Writing log events to CloudWatch
data "aws_iam_policy_document" "lambda_execution_policy" {
  # Permission to create CloudWatch Log Groups
  # Required for Lambda to create log groups if they don't exist
  statement {
    sid    = ""      # Statement ID (optional)
    effect = "Allow" # Allow the specified actions

    # CloudWatch Logs action for creating log groups
    actions = ["logs:CreateLogGroup"]

    # Resources this permission applies to
    # Allows creating log groups in the current account and region
    resources = [
      # General permission for all log groups in the account/region
      "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:*",
      # Specific permission for this Lambda function's log group
      "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/manually-created-lambda:*"
    ]
  }

  # Permission to create log streams and write log events
  # Required for Lambda to write logs to CloudWatch
  statement {
    sid    = ""      # Statement ID (optional)
    effect = "Allow" # Allow the specified actions

    # CloudWatch Logs actions for logging
    actions = [
      "logs:CreateLogStream", # Create log streams within log groups
      "logs:PutLogEvents"     # Write log events to log streams
    ]

    # Resource ARN for the specific log group created for this Lambda
    # The :* suffix allows access to all log streams within the log group
    resources = ["${aws_cloudwatch_log_group.lambda.arn}:*"]
  }
}

# IAM policy resource based on the policy document
# This creates the actual IAM policy that can be attached to roles
resource "aws_iam_policy" "lambda_execution_policy" {
  # Policy name with unique identifier (mimics AWS console naming)
  name = "AWSLambdaBasicExecutionRole-501c1f2b-0b64-404d-bca4-161eed0fe490"

  # Path for organizing policies (AWS service role convention)
  path = "/service-role/"

  # Policy document in JSON format from the data source
  policy = data.aws_iam_policy_document.lambda_execution_policy.json
}

# IAM role for Lambda function execution
# This role will be assumed by the Lambda service when executing the function
resource "aws_iam_role" "lambda_execution_role" {
  # Trust policy (assume role policy) from the data source
  # Defines which entities can assume this role
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_execution_role.json

  # Maximum session duration for role assumption (1 hour)
  # Lambda functions typically have short execution times
  max_session_duration = 3600

  # Role name with unique identifier (mimics AWS console naming)
  name = "manually-created-lambda-role-tc6bityn"

  # Path for organizing roles (AWS service role convention)
  path = "/service-role/"
}

# Attach the execution policy to the Lambda execution role
# This grants the Lambda function the permissions defined in the policy
resource "aws_iam_role_policy_attachment" "lambda_execution_policy_attachment" {
  # ARN of the policy to attach
  policy_arn = aws_iam_policy.lambda_execution_policy.arn

  # Name of the role to attach the policy to
  role = aws_iam_role.lambda_execution_role.name
}