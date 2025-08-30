# IAM Role Management Project

## Overview

This Terraform project implements a comprehensive Identity and Access Management (IAM) solution for AWS environments. It automates the creation and management of IAM users, roles, and their associated permissions using a declarative YAML configuration approach.

## 🎯 Project Purpose

The primary goal of this project is to:

- **Centralize User Management**: Manage all IAM users and their role assignments from a single YAML configuration file
- **Implement Role-Based Access Control (RBAC)**: Provide granular permission control through predefined roles
- **Automate User Provisioning**: Streamline the process of creating new users with appropriate permissions
- **Enhance Security**: Implement least-privilege access principles and secure role assumption patterns
- **Simplify Administration**: Reduce manual IAM configuration and potential human errors

## 🏗️ Architecture

### Components

1. **User Management** (`iam.tf`)
   - Creates IAM users based on YAML configuration
   - Generates secure login profiles with temporary passwords
   - Manages console access credentials

2. **Role Management** (`roles.tf`)
   - Defines four distinct roles with specific permission sets
   - Creates assume role policies for secure role switching
   - Attaches AWS managed policies to roles

3. **Configuration** (`users-roles.yaml`)
   - Declarative user and role assignment configuration
   - Single source of truth for access control
   - Easy to modify and version control

### Role Definitions

| Role | Purpose | Permissions | Use Case |
|------|---------|-------------|----------|
| **readonly** | View-only access | `ReadOnlyAccess` | Auditors, junior staff, external consultants |
| **admin** | Full administrative access | `AdministratorAccess` | System administrators, senior engineers |
| **securityAudit** | Security compliance | `SecurityAudit` | Security teams, compliance officers |
| **developer** | Development services | VPC, EC2, S3, Lambda, RDS Full Access | Application developers, DevOps engineers |

## 📁 Project Structure

```
21_IAM_Create_Role_Project/
├── README.md                 # This documentation file
├── iam.tf                   # User creation and login profile management
├── roles.tf                 # Role definitions and policy attachments
├── users-roles.yaml         # User and role configuration
├── versions.tf              # Terraform and provider version constraints
└── .terraform/              # Terraform state and provider cache
```

## 🚀 Getting Started

### Prerequisites

- **Terraform**: Version 1.8.x or compatible
- **AWS CLI**: Configured with appropriate credentials
- **AWS Account**: With IAM permissions to create users and roles
- **Access**: Administrative privileges in the target AWS account

### Installation & Deployment

1. **Clone and Navigate**
   ```bash
   cd 21_IAM_Create_Role_Project
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review Configuration**
   - Edit `users-roles.yaml` to define your users and role assignments
   - Verify the role definitions in `roles.tf` match your requirements

4. **Plan Deployment**
   ```bash
   terraform plan
   ```

5. **Apply Configuration**
   ```bash
   terraform apply
   ```

6. **Retrieve Initial Passwords**
   ```bash
   terraform output -json passwords
   ```

## ⚙️ Configuration

### Adding New Users

Edit `users-roles.yaml`:

```yaml
users:
- username: newuser
  roles: [developer, readonly]  # Assign multiple roles as needed
```

### Available Roles

- `readonly`: Read-only access to all AWS services
- `admin`: Full administrative access (use sparingly)
- `securityAudit`: Security and compliance auditing
- `developer`: Development-focused service access

### Modifying Role Permissions

To modify role permissions, edit the `roles_policies` local variable in `roles.tf`:

```hcl
locals {
  roles_policies = {
    developer = [
      "AmazonVPCFullAccess",
      "AmazonEC2FullAccess",
      # Add or remove policies as needed
    ]
  }
}
```

## 🔐 Security Features

### Access Control
- **Principle of Least Privilege**: Users receive only necessary permissions
- **Role-Based Access**: Permissions granted through role assumption
- **Temporary Passwords**: Users must change passwords on first login

### Assume Role Security
- **User-Specific Policies**: Each role can only be assumed by designated users
- **Account-Scoped**: Role assumption limited to current AWS account
- **Audit Trail**: All role assumptions logged via CloudTrail

### Password Management
- **Secure Generation**: 10-character passwords with complexity requirements
- **Forced Reset**: Users must change passwords on first login
- **Sensitive Output**: Passwords marked as sensitive in Terraform state

## 📊 Usage Examples

### User Login Process
1. User receives initial credentials from administrator
2. User logs into AWS Console with temporary password
3. User is prompted to set a new password
4. User can then assume assigned roles as needed

### Role Assumption (AWS CLI)
```bash
# Assume the developer role
aws sts assume-role \
  --role-arn arn:aws:iam::ACCOUNT-ID:role/developer \
  --role-session-name developer-session

# Use temporary credentials for development tasks
export AWS_ACCESS_KEY_ID=<temporary-access-key>
export AWS_SECRET_ACCESS_KEY=<temporary-secret-key>
export AWS_SESSION_TOKEN=<session-token>
```

### Role Assumption (AWS Console)
1. Log in with user credentials
2. Click on username in top-right corner
3. Select "Switch Role"
4. Enter account ID and role name
5. Assume role and access permitted services

## 🔧 Maintenance

### Regular Tasks
- **Review User Access**: Periodically audit user role assignments
- **Update Permissions**: Modify role policies as business needs change
- **Remove Inactive Users**: Clean up unused accounts promptly
- **Monitor Usage**: Review CloudTrail logs for role assumption patterns

### Terraform State Management
- **State Backup**: Regularly backup Terraform state files
- **Remote State**: Consider using S3 backend for team collaboration
- **State Locking**: Implement DynamoDB locking for concurrent access prevention

## 🚨 Important Notes

### Security Considerations
- **Initial Passwords**: Retrieve and securely distribute initial passwords
- **Role Assignment**: Regularly review and update user role assignments
- **Admin Role**: Limit admin role assignment to trusted personnel only
- **Monitoring**: Enable CloudTrail for comprehensive audit logging

### Operational Considerations
- **Testing**: Always test changes in a non-production environment first
- **Backup**: Maintain backups of configuration files and Terraform state
- **Documentation**: Keep role definitions and user assignments documented
- **Compliance**: Ensure role permissions align with organizational policies

## 📝 Troubleshooting

### Common Issues

**Issue**: User cannot assume role
- **Solution**: Verify user is listed in the role's assume role policy
- **Check**: Confirm user exists in `users-roles.yaml` with correct role assignment

**Issue**: Permission denied errors
- **Solution**: Review role policies and ensure required permissions are attached
- **Check**: Verify AWS managed policy names are correct in `roles.tf`

**Issue**: Terraform apply fails
- **Solution**: Check AWS credentials and IAM permissions
- **Check**: Ensure Terraform has necessary permissions to create IAM resources

### Support Resources
- [AWS IAM Documentation](https://docs.aws.amazon.com/iam/)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)

## 📄 License

This project is provided as-is for educational and operational purposes. Please ensure compliance with your organization's security policies and AWS best practices when implementing in production environments.

---

**Last Updated**: $(date)
**Terraform Version**: ~> 1.8
**AWS Provider Version**: ~> 6.0