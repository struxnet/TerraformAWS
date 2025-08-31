# =============================================================================
# LAMBDA FUNCTION CONFIGURATION
# =============================================================================
# This file defines the AWS Lambda function and its deployment package.
# It includes the function code packaging, runtime configuration,
# and integration with IAM roles and CloudWatch logging.

# Data source to create a ZIP archive of the Lambda function code
# This packages the source code into a deployment-ready ZIP file
# that can be uploaded to AWS Lambda
data "archive_file" "lambda_zip" {
  # Archive type - ZIP is the standard format for Lambda deployments
  type = "zip"

  # Source file containing the Lambda function code
  # Points to the main JavaScript/Node.js file with the handler function
  # ${path.root} refers to the root directory of the Terraform configuration
  source_file = "${path.root}/build/index.mjs"

  # Output path where the ZIP file will be created
  # This file will be uploaded to Lambda as the function code
  output_path = "${path.root}/lambda.zip"
}

# AWS Lambda function resource
# This creates and configures the serverless function with all necessary settings
# for execution, logging, and performance
resource "aws_lambda_function" "this" {
  # CPU architecture for the Lambda function
  # x86_64 is the standard architecture, arm64 is also available for cost optimization
  architectures = ["x86_64"]

  # Human-readable description of the function's purpose
  # Helps with documentation and function identification in the AWS console
  description = "A starter AWS Lambda function."

  # Path to the deployment package (ZIP file)
  # This file contains the function code and dependencies
  filename = "lambda.zip"

  # Unique name for the Lambda function
  # Must be unique within the AWS account and region
  function_name = "manually-created-lambda"

  # Entry point for the Lambda function
  # Format: {filename}.{function_name}
  # Points to the 'handler' function in the 'index' file
  handler = "index.handler"

  # AWS region where the function will be deployed
  # Note: This parameter is deprecated in newer AWS provider versions
  # The provider region configuration is typically used instead
  region = "us-west-1"

  # Concurrent execution limit for the function
  # -1 means no limit (use account-level concurrency limit)
  # Positive numbers set a specific limit for this function
  reserved_concurrent_executions = -1

  # IAM role ARN that the Lambda function will assume during execution
  # This role must have permissions for Lambda execution and any AWS services the function uses
  role = aws_iam_role.lambda_execution_role.arn

  # Runtime environment for the Lambda function
  # nodejs22.x is the latest Node.js runtime (as of 2024)
  # Other options: python3.12, java21, dotnet8, go1.x, etc.
  runtime = "nodejs22.x"

  # Whether to skip deletion of the function when destroying the resource
  # false means the function will be deleted when the Terraform resource is destroyed
  skip_destroy = false

  # Hash of the deployment package content
  # Used by Terraform to detect changes in the function code
  # When this changes, Terraform will update the function with new code
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  # Resource tags for organization and cost tracking
  # The lambda-console:blueprint tag indicates this was created from a blueprint
  tags = {
    "lambda-console:blueprint" = "hello-world"
  }

  # Environment variables configuration block
  # Currently empty but can be used to pass configuration to the function
  environment {
    variables = {
      # Example environment variables:
      # NODE_ENV = "production"
      # API_ENDPOINT = "https://api.example.com"
      # LOG_LEVEL = "info"
    }
  }

  # Logging configuration for the Lambda function
  # Defines how logs are formatted and where they are sent
  logging_config {
    # Log format - "Text" for plain text, "JSON" for structured logging
    # Text format is more readable for simple applications
    log_format = "Text"

    # CloudWatch Log Group where function logs will be sent
    # References the log group created in cloudwatch.tf
    log_group = aws_cloudwatch_log_group.lambda.name
  }

  # Additional configurations that can be added:
  # timeout                        = 3           # Function timeout in seconds (default: 3, max: 900)
  # memory_size                   = 128         # Memory allocation in MB (128-10240)
  # publish                       = false       # Whether to publish a version
  # layers                        = []          # Lambda layers to include
  # dead_letter_config { ... }                 # Dead letter queue configuration
  # vpc_config { ... }                         # VPC configuration for private resources
  # file_system_config { ... }                 # EFS file system configuration
}

# Creating functional URL to invoke function from the public URL.
resource "aws_lambda_function_url" "this" {
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"
}
