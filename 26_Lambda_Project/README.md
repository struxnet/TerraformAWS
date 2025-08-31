# AWS Lambda Function Management Project

## Overview

This project demonstrates comprehensive AWS Lambda function management using Terraform, including the import of existing Lambda functions into Terraform state management. It showcases best practices for serverless infrastructure as code, IAM security, CloudWatch logging, and the integration of multiple AWS services in a Lambda-centric architecture.

## 🎯 Project Purpose

The primary objectives of this project are to:

- **Import Existing Lambda Functions**: Demonstrate how to bring manually created Lambda functions under Terraform management
- **Implement Security Best Practices**: Create proper IAM roles and policies following the principle of least privilege
- **Enable Comprehensive Logging**: Set up CloudWatch logging with proper permissions and configuration
- **Automate Deployment**: Provide a complete Infrastructure as Code solution for Lambda functions
- **Demonstrate Integration**: Show how Lambda integrates with other AWS services through Terraform

## 🏗️ Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    AWS Lambda Architecture                  │
│                                                             │
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │   Lambda        │    │   CloudWatch    │                │
│  │   Function      │───▶│   Logs          │                │
│  │                 │    │                 │                │
│  │ • Node.js 22.x  │    │ • Log Group     │                │
│  │ • x86_64 Arch   │    │ • Log Streams   │                │
│  │ • ZIP Package   │    │ • Log Events    │                │
│  └─────────────────┘    └─────────────────┘                │
│           │                                                 │
│           ▼                                                 │
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │   IAM Role      │    │   IAM Policy    │                │
│  │                 │◀───│                 │                │
│  │ • Execution     │    │ • Log Creation  │                │
│  │ • AssumeRole    │    │ • Log Writing   │                │
│  │ • Service Role  │    │ • Least Privilege│               │
│  └─────────────────┘    └─────────────────┘                │
└─────────────────────────────────────────────────────────────┘
```

### Component Architecture

#### Lambda Function
- **Runtime**: Node.js 22.x (latest LTS)
- **Architecture**: x86_64 for broad compatibility
- **Deployment**: ZIP package from source code
- **Handler**: `index.handler` entry point

#### IAM Security
- **Execution Role**: Service role for Lambda execution
- **Custom Policy**: Minimal permissions for logging
- **Trust Policy**: Allows Lambda service to assume role

#### CloudWatch Integration
- **Log Group**: Dedicated log group for function logs
- **Import Management**: Existing resources brought under Terraform control
- **Structured Logging**: Configurable log format and retention

## 📁 Project Structure

```
26_Lambda_Project/
├── README.md                    # This documentation
├── versions.tf                  # Terraform and provider configuration
├── iam.tf                      # IAM roles and policies
├── cloudwatch.tf               # CloudWatch log group configuration
├── lambda.tf                   # Lambda function definition
├── lambda.zip                  # Packaged function code (generated)
├── build/                      # Source code directory (referenced)
│   └── index.mjs              # Lambda function source code
├── .terraform.lock.hcl         # Provider version lock file
└── terraform.tfstate*          # Terraform state files
```

## 🚀 Getting Started

### Prerequisites

- **Terraform**: Version 1.0+ 
- **AWS CLI**: Configured with appropriate credentials
- **AWS Account**: With Lambda and IAM permissions
- **Node.js**: For local development and testing (optional)

### Quick Start

1. **Clone and Navigate**
   ```bash
   cd 26_Lambda_Project
   ```

2. **Prepare Function Code**
   ```bash
   # Create build directory if it doesn't exist
   mkdir -p build
   
   # Create a simple Lambda function (example)
   cat > build/index.mjs << 'EOF'
   export const handler = async (event) => {
       console.log('Event:', JSON.stringify(event, null, 2));
       
       const response = {
           statusCode: 200,
           body: JSON.stringify({
               message: 'Hello from Lambda!',
               timestamp: new Date().toISOString(),
               event: event
           }),
       };
       
       return response;
   };
   EOF
   ```

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Review Configuration**
   ```bash
   terraform plan
   ```

5. **Deploy Infrastructure**
   ```bash
   terraform apply
   ```

6. **Test the Function**
   ```bash
   aws lambda invoke \
     --function-name manually-created-lambda \
     --payload '{"test": "data"}' \
     response.json
   
   cat response.json
   ```

## 🔧 Configuration Details

### Lambda Function Configuration

The Lambda function is configured with the following specifications:

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Runtime** | `nodejs22.x` | Latest Node.js runtime |
| **Architecture** | `x86_64` | Standard CPU architecture |
| **Handler** | `index.handler` | Entry point function |
| **Memory** | 128 MB (default) | Memory allocation |
| **Timeout** | 3 seconds (default) | Execution timeout |
| **Concurrency** | Unlimited | Concurrent executions |

### IAM Configuration

The project implements a secure IAM setup:

#### Execution Role
- **Name**: `manually-created-lambda-role-tc6bityn`
- **Type**: Service role for Lambda
- **Path**: `/service-role/`
- **Session Duration**: 1 hour

#### Custom Policy
- **Name**: `AWSLambdaBasicExecutionRole-501c1f2b-0b64-404d-bca4-161eed0fe490`
- **Permissions**:
  - `logs:CreateLogGroup` - Create CloudWatch log groups
  - `logs:CreateLogStream` - Create log streams
  - `logs:PutLogEvents` - Write log events

### CloudWatch Configuration

- **Log Group**: `/aws/lambda/manually-created-lambda`
- **Region**: `us-west-1`
- **Format**: Text (human-readable)
- **Retention**: Default (never expire)

## 📊 Import Functionality

This project demonstrates Terraform's import functionality for existing AWS resources:

### Import Block Usage

```hcl
import {
  to = aws_cloudwatch_log_group.lambda
  id = "/aws/lambda/manually-created-lambda"
}
```

### Import Process

1. **Identify Existing Resource**: Find the AWS resource ID
2. **Define Terraform Resource**: Create matching resource configuration
3. **Import Statement**: Use import block to associate existing resource
4. **State Synchronization**: Terraform brings resource under management

### Benefits of Import

- **No Downtime**: Existing resources continue operating
- **Gradual Migration**: Move to Infrastructure as Code incrementally
- **State Management**: Gain Terraform state tracking for existing resources
- **Configuration Drift**: Detect and manage configuration changes

## 🔐 Security Features

### IAM Best Practices

- **Principle of Least Privilege**: Only necessary permissions granted
- **Service-Specific Roles**: Dedicated role for Lambda execution
- **Resource-Specific Permissions**: Scoped to specific log groups
- **Trust Policies**: Explicit service principal definitions

### Lambda Security

- **Execution Role**: Separate role for function execution
- **Environment Isolation**: Function runs in isolated environment
- **Network Security**: No VPC configuration (public Lambda)
- **Code Integrity**: Source code hash validation

### Logging Security

- **Dedicated Log Groups**: Isolated logging per function
- **Access Control**: IAM-controlled log access
- **Audit Trail**: Complete execution logging
- **Retention Policies**: Configurable log retention

## 🛠️ Customization Options

### Function Configuration

```hcl
resource "aws_lambda_function" "this" {
  # Performance tuning
  memory_size = 256        # Increase memory allocation
  timeout     = 30         # Extend timeout for longer operations
  
  # Environment variables
  environment {
    variables = {
      NODE_ENV     = "production"
      LOG_LEVEL    = "info"
      API_ENDPOINT = "https://api.example.com"
    }
  }
  
  # VPC configuration for private resources
  vpc_config {
    subnet_ids         = ["subnet-12345", "subnet-67890"]
    security_group_ids = ["sg-12345"]
  }
  
  # Dead letter queue for error handling
  dead_letter_config {
    target_arn = aws_sqs_queue.dlq.arn
  }
}
```

### Enhanced Logging

```hcl
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/manually-created-lambda"
  retention_in_days = 14
  
  # Encryption with KMS
  kms_key_id = aws_kms_key.logs.arn
  
  tags = {
    Environment = "production"
    Purpose     = "lambda-logs"
  }
}
```

### Advanced IAM Policies

```hcl
data "aws_iam_policy_document" "lambda_execution_policy" {
  # Additional permissions for S3 access
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["arn:aws:s3:::my-bucket/*"]
  }
  
  # DynamoDB permissions
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]
    resources = ["arn:aws:dynamodb:*:*:table/my-table"]
  }
}
```

## 📈 Monitoring and Observability

### CloudWatch Metrics

Lambda automatically provides metrics:
- **Invocations**: Number of function executions
- **Duration**: Execution time per invocation
- **Errors**: Number of failed executions
- **Throttles**: Number of throttled invocations

### Custom Metrics

```javascript
// In your Lambda function
import { CloudWatch } from '@aws-sdk/client-cloudwatch';

const cloudwatch = new CloudWatch({ region: 'us-west-1' });

export const handler = async (event) => {
    // Custom metric
    await cloudwatch.putMetricData({
        Namespace: 'MyApp/Lambda',
        MetricData: [{
            MetricName: 'ProcessedItems',
            Value: event.items.length,
            Unit: 'Count'
        }]
    });
    
    // Function logic here
};
```

### Alarms and Notifications

```hcl
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "lambda-error-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = "5"
  alarm_description   = "This metric monitors lambda errors"
  
  dimensions = {
    FunctionName = aws_lambda_function.this.function_name
  }
  
  alarm_actions = [aws_sns_topic.alerts.arn]
}
```

## 🚨 Best Practices Implemented

### Code Organization
- **Separation of Concerns**: Each file handles specific AWS services
- **Modular Design**: Resources logically grouped by functionality
- **Clear Naming**: Descriptive resource and variable names
- **Comprehensive Comments**: Detailed explanations for all configurations

### Security Practices
- **Least Privilege IAM**: Minimal required permissions only
- **Resource-Specific Policies**: Scoped to exact resources needed
- **Service Roles**: Dedicated roles for specific services
- **Trust Policies**: Explicit principal definitions

### Operational Excellence
- **Infrastructure as Code**: All resources defined in Terraform
- **Version Control**: Configuration tracked in version control
- **Import Strategy**: Existing resources brought under management
- **State Management**: Proper Terraform state handling

### Performance Optimization
- **Appropriate Sizing**: Right-sized memory and timeout settings
- **Efficient Packaging**: Minimal deployment package size
- **Cold Start Optimization**: Runtime and architecture choices
- **Monitoring Integration**: Comprehensive observability setup

## 🔧 Troubleshooting

### Common Issues

#### Import Errors
```
Error: resource already exists
```
**Solution**: Ensure the import block matches exactly with existing resource
```bash
# Check existing resource
aws logs describe-log-groups --log-group-name-prefix "/aws/lambda/"

# Verify import configuration
terraform plan
```

#### Permission Errors
```
Error: AccessDenied when calling CreateLogGroup
```
**Solution**: Verify IAM permissions and policy attachments
```bash
# Check role policies
aws iam list-attached-role-policies --role-name manually-created-lambda-role-tc6bityn

# Test policy simulation
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::ACCOUNT:role/service-role/manually-created-lambda-role-tc6bityn \
  --action-names logs:CreateLogGroup
```

#### Function Update Issues
```
Error: source code hash mismatch
```
**Solution**: Ensure source code changes trigger archive recreation
```bash
# Force archive recreation
rm lambda.zip
terraform apply
```

### Debugging Tips

1. **Enable Terraform Debug Logging**:
   ```bash
   export TF_LOG=DEBUG
   terraform apply
   ```

2. **Check Lambda Function Logs**:
   ```bash
   aws logs tail /aws/lambda/manually-created-lambda --follow
   ```

3. **Test Function Locally**:
   ```bash
   # Using AWS SAM CLI
   sam local invoke -e test-event.json
   ```

4. **Validate IAM Policies**:
   ```bash
   aws iam validate-policy-document --policy-document file://policy.json
   ```

## 📚 Additional Resources

### AWS Documentation
- [AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/)
- [IAM Roles for Lambda](https://docs.aws.amazon.com/lambda/latest/dg/lambda-intro-execution-role.html)
- [CloudWatch Logs for Lambda](https://docs.aws.amazon.com/lambda/latest/dg/monitoring-cloudwatchlogs.html)

### Terraform Documentation
- [Terraform AWS Provider - Lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)
- [Terraform Import](https://www.terraform.io/docs/import/index.html)
- [Archive Provider](https://registry.terraform.io/providers/hashicorp/archive/latest/docs)

### Best Practices
- [AWS Lambda Best Practices](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html)
- [Serverless Security Best Practices](https://aws.amazon.com/blogs/compute/security-best-practices-for-aws-lambda/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

## 🤝 Contributing

Contributions are welcome! Please ensure that:

1. **Code Quality**: All code is properly formatted (`terraform fmt`)
2. **Validation**: Configuration is valid (`terraform validate`)
3. **Documentation**: Comments and documentation are updated
4. **Security**: IAM policies follow least privilege principles
5. **Testing**: Changes are tested in a development environment

## 📄 License

This project is provided as-is for educational and operational purposes. Please ensure compliance with your organization's security policies and AWS best practices when implementing in production environments.

---

**Project Type**: AWS Lambda Infrastructure as Code  
**Terraform Version**: >= 1.0  
**AWS Provider Version**: ~> 6.0  
**Archive Provider Version**: ~> 2.0  
**Last Updated**: $(date)  
**Tested Region**: us-west-1