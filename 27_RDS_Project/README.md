# AWS RDS Database Deployment Project

## Overview

This project demonstrates comprehensive AWS RDS (Relational Database Service) deployment using Terraform with a focus on security best practices, compliance validation, and modular architecture. It showcases how to create secure, production-ready database infrastructure with proper network isolation, access controls, and automated validation of security configurations.

## 🎯 Project Purpose

The primary objectives of this project are to:

- **Demonstrate Secure RDS Deployment**: Implement database infrastructure following AWS security best practices
- **Showcase Compliance Validation**: Automated validation of network and security configurations
- **Implement Modular Architecture**: Reusable RDS module with comprehensive input validation
- **Enforce Security Standards**: Prevent common security misconfigurations through validation rules
- **Enable Multi-AZ Deployment**: High availability database setup across multiple availability zones

## 🏗️ Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Custom VPC (10.0.0.0/16)                    │
│                                                                 │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │  Private Subnet │  │  Private Subnet │  │  Private Subnet │ │
│  │  (10.0.1.0/24)  │  │  (10.0.2.0/24)  │  │  (10.0.3.0/24)  │ │
│  │   us-west-1b    │  │   us-west-1c    │  │   (auto-AZ)     │ │
│  │                 │  │                 │  │                 │ │
│  │  ┌─────────────┐│  │                 │  │                 │ │
│  │  │    RDS      ││  │                 │  │                 │ │
│  │  │ PostgreSQL  ││  │                 │  │                 │ │
│  │  │   16.1      ││  │                 │  │                 │ │
│  │  │ db.t3.micro ││  │                 │  │                 │ │
│  │  └─────────────┘│  │                 │  │                 │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                Security Groups                              │ │
│  │  ┌─────────────┐    ┌─────────────┐    ┌─────────────────┐ │ │
│  │  │ Allowed SG  │───▶│Compliant SG │    │Non-Compliant SG │ │ │
│  │  │(App Servers)│    │(RDS Access) │    │ (Demo Only)     │ │ │
│  │  └─────────────┘    └─────────────┘    └─────────────────┘ │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Component Architecture

#### RDS Module (`./modules/rds/`)
- **Database Instance**: PostgreSQL 16.1 on db.t3.micro
- **Subnet Group**: Multi-AZ deployment across private subnets
- **Parameter Group**: Custom configuration with connection logging
- **Security Validation**: Comprehensive network and security checks

#### Network Infrastructure
- **Custom VPC**: Isolated network environment (10.0.0.0/16)
- **Private Subnets**: Three subnets across multiple AZs
- **Security Groups**: Compliant and non-compliant examples

#### Validation Framework
- **Subnet Validation**: Prevents default VPC usage and ensures private subnets
- **Security Group Validation**: Enforces security group-based access only
- **Input Validation**: Comprehensive variable validation with security requirements

## 📁 Project Structure

```
27_RDS_Project/
├── README.md                    # This documentation
├── main.tf                     # RDS module instantiation
├── networks.tf                 # VPC and subnet configuration
├── sgs.tf                      # Security group definitions
├── versions.tf                 # Terraform and provider configuration
├── .terraform.lock.hcl         # Provider version lock file
├── terraform.tfstate*          # Terraform state files
└── modules/
    └── rds/                    # Custom RDS module
        ├── rds.tf              # RDS instance and related resources
        ├── variables.tf        # Module input variables with validation
        ├── outputs.tf          # Module outputs
        ├── networks.tf         # Network and security validation
        └── versions.tf         # Module provider requirements
```

## 🚀 Getting Started

### Prerequisites

- **Terraform**: Version 1.0+
- **AWS CLI**: Configured with appropriate credentials
- **AWS Account**: With RDS and VPC creation permissions
- **Permissions**: EC2, RDS, and IAM service permissions

### Quick Start

1. **Clone and Navigate**
   ```bash
   cd 27_RDS_Project
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review Configuration**
   ```bash
   terraform plan
   ```

4. **Deploy Infrastructure**
   ```bash
   terraform apply
   ```

5. **Connect to Database**
   ```bash
   # Get the database endpoint from outputs
   terraform output
   
   # Connect using psql (example)
   psql -h <db_endpoint> -U dbadmin -d postgres
   ```

6. **Clean Up Resources**
   ```bash
   terraform destroy
   ```

## 🔧 Configuration Details

### RDS Instance Specifications

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Engine** | PostgreSQL 16.1 | Latest stable PostgreSQL version |
| **Instance Class** | db.t3.micro | Free tier eligible instance |
| **Storage** | 10 GB | Cost-effective storage allocation |
| **Multi-AZ** | Yes | High availability deployment |
| **Public Access** | No | Private subnet deployment only |
| **Backup** | Enabled | Automated backup configuration |

### Network Configuration

| Component | Configuration | Purpose |
|-----------|---------------|---------|
| **VPC** | 10.0.0.0/16 | Isolated network environment |
| **Private Subnets** | 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24 | Database deployment subnets |
| **Availability Zones** | us-west-1b, us-west-1c, auto | Multi-AZ high availability |
| **Security Groups** | Compliant SG with restricted access | Database access control |

### Security Features

- **Private Subnet Deployment**: No direct internet access
- **Security Group Validation**: Only security group-based access allowed
- **Default VPC Prevention**: Automated validation prevents default VPC usage
- **Strong Password Requirements**: Enforced password complexity
- **Connection Logging**: Enabled for security auditing

## 🔐 Security Validation

### Subnet Validation Rules

The module implements comprehensive subnet validation:

```hcl
# Validation 1: Prevent Default VPC Usage
condition = self.vpc_id != data.aws_vpc.default.id

# Validation 2: Ensure Private Subnet
condition = can(lower(self.tags.Access) == "private")
```

### Security Group Validation Rules

Security groups must follow strict access patterns:

```hcl
# Only security group references allowed (no CIDR blocks)
condition = (
  self.is_egress ? true : 
  (self.cidr_ipv4 == null && self.cidr_ipv6 == null && 
   self.referenced_security_group_id != null)
)
```

### Variable Validation

Input variables include comprehensive validation:

- **Instance Class**: Restricted to free tier instances
- **Storage Size**: Limited to 5-15 GB range
- **Password Complexity**: Minimum 8 characters with alphanumeric and special characters
- **Engine Selection**: Limited to supported database engines

## 🛠️ Customization Options

### Database Engine Configuration

```hcl
# Add new engine configurations
locals {
  db_engine = {
    mysql-latest = {
      engine  = "mysql"
      version = "8.0.35"
      family  = "mysql8.0"
    }
    postgres-15 = {
      engine  = "postgres"
      version = "15.4"
      family  = "postgres15"
    }
  }
}
```

### Custom Parameter Groups

```hcl
# Add custom database parameters
parameter {
  name  = "shared_preload_libraries"
  value = "pg_stat_statements"
}

parameter {
  name  = "log_statement"
  value = "all"
}
```

### Enhanced Security Groups

```hcl
# Application server security group
resource "aws_security_group" "app_servers" {
  name_prefix = "app-servers-"
  vpc_id      = aws_vpc.db_vpc.id
  
  # Allow outbound database connections
  egress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.compliant.id]
  }
}
```

## 📊 Module Usage Examples

### Basic Usage

```hcl
module "database" {
  source = "./modules/rds"
  
  project_name   = "my-app"
  instance_class = "db.t3.micro"
  storage_size   = 10
  engine         = "postgres-latest"
  
  credentials = {
    username = "dbadmin"
    password = "SecurePass123!"
  }
  
  security_group_ids = [aws_security_group.db_access.id]
  subnet_ids         = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}
```

### Advanced Configuration

```hcl
module "production_database" {
  source = "./modules/rds"
  
  project_name   = "production-app"
  instance_class = "db.t3.micro"
  storage_size   = 15
  engine         = "postgres-latest"
  
  credentials = {
    username = "prodadmin"
    password = var.db_password  # From AWS Secrets Manager
  }
  
  security_group_ids = [
    aws_security_group.app_servers.id,
    aws_security_group.monitoring.id
  ]
  
  subnet_ids = [
    aws_subnet.private_db_1.id,
    aws_subnet.private_db_2.id,
    aws_subnet.private_db_3.id
  ]
}
```

## 📈 Monitoring and Maintenance

### CloudWatch Integration

The RDS instance automatically provides metrics:
- **CPU Utilization**: Database server performance
- **Database Connections**: Active connection count
- **Read/Write IOPS**: Storage performance metrics
- **Free Storage Space**: Available storage monitoring

### Parameter Group Monitoring

```sql
-- Check connection logging status
SHOW log_connections;

-- View active connections
SELECT * FROM pg_stat_activity;

-- Monitor database performance
SELECT * FROM pg_stat_database;
```

### Backup and Recovery

```bash
# Create manual snapshot
aws rds create-db-snapshot \
  --db-instance-identifier rds-project-terraform-db-instance \
  --db-snapshot-identifier manual-snapshot-$(date +%Y%m%d)

# List available snapshots
aws rds describe-db-snapshots \
  --db-instance-identifier rds-project-terraform-db-instance
```

## 🚨 Best Practices Implemented

### Security Best Practices
- **Network Isolation**: Private subnet deployment only
- **Access Control**: Security group-based access restrictions
- **Credential Management**: Strong password requirements
- **Audit Logging**: Connection logging enabled
- **Encryption**: At-rest and in-transit encryption support

### Operational Best Practices
- **Multi-AZ Deployment**: High availability configuration
- **Automated Backups**: Point-in-time recovery capability
- **Parameter Groups**: Custom database configuration
- **Monitoring**: CloudWatch metrics integration
- **Tagging**: Consistent resource tagging

### Development Best Practices
- **Modular Design**: Reusable RDS module
- **Input Validation**: Comprehensive variable validation
- **Error Handling**: Clear error messages and resolution guidance
- **Documentation**: Extensive code comments and documentation

## 🔧 Troubleshooting

### Common Issues

#### Subnet Validation Errors
```
Error: Subnet subnet-xxx is part of the default VPC
```
**Solution**: Use subnets from a custom VPC with proper tagging
```bash
# Check subnet details
aws ec2 describe-subnets --subnet-ids subnet-xxx

# Ensure subnet has Access = Private tag
aws ec2 create-tags --resources subnet-xxx --tags Key=Access,Value=Private
```

#### Security Group Validation Errors
```
Error: Security Group Rule allows inbound traffic from IP CIDR blocks
```
**Solution**: Use security group references instead of CIDR blocks
```hcl
# Incorrect - uses CIDR block
cidr_ipv4 = "10.0.0.0/16"

# Correct - uses security group reference
referenced_security_group_id = aws_security_group.app_servers.id
```

#### Password Validation Errors
```
Error: Password must contain alphanumeric and special characters
```
**Solution**: Ensure password meets complexity requirements
- Minimum 8 characters
- Contains letters and numbers
- Includes special characters: +_?-@!

### Debugging Tips

1. **Validate Configuration**:
   ```bash
   terraform validate
   terraform plan
   ```

2. **Check AWS Resources**:
   ```bash
   # List RDS instances
   aws rds describe-db-instances
   
   # Check security groups
   aws ec2 describe-security-groups
   
   # Verify subnets
   aws ec2 describe-subnets
   ```

3. **Test Database Connectivity**:
   ```bash
   # Test from EC2 instance in allowed security group
   telnet <db_endpoint> 5432
   
   # Connect with psql
   psql -h <db_endpoint> -U dbadmin -d postgres
   ```

## 📚 Additional Resources

### AWS Documentation
- [Amazon RDS User Guide](https://docs.aws.amazon.com/rds/latest/userguide/)
- [RDS Security Best Practices](https://docs.aws.amazon.com/rds/latest/userguide/CHAP_BestPractices.Security.html)
- [VPC Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)

### Terraform Documentation
- [Terraform AWS Provider - RDS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)
- [Terraform Validation](https://www.terraform.io/docs/language/values/variables.html#custom-validation-rules)
- [Terraform Modules](https://www.terraform.io/docs/language/modules/index.html)

### PostgreSQL Resources
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [PostgreSQL Performance Tuning](https://wiki.postgresql.org/wiki/Performance_Optimization)
- [PostgreSQL Security](https://www.postgresql.org/docs/current/security.html)

## 🤝 Contributing

Contributions are welcome! Please ensure that:

1. **Security First**: All changes maintain or improve security posture
2. **Validation**: Add appropriate validation rules for new features
3. **Documentation**: Update comments and documentation
4. **Testing**: Test in development environment before production
5. **Compliance**: Ensure changes meet organizational security policies

## 📄 License

This project is provided for educational and operational purposes. Please ensure compliance with your organization's security policies and AWS best practices when implementing in production environments.

---

**Project Type**: AWS RDS Infrastructure with Security Validation  
**Terraform Version**: ~> 1.0  
**AWS Provider Version**: ~> 6.0  
**Database Engine**: PostgreSQL 16.1  
**Last Updated**: $(date)  
**Tested Region**: us-west-1

Comments are generated by Amazon Q for better understanding and explanation of code