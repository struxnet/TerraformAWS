# VPC Module Project

## Overview

This project demonstrates advanced Terraform module development and usage patterns by creating a reusable VPC network module and showcasing its implementation. The project consists of a custom network module that creates comprehensive VPC infrastructure and a root configuration that demonstrates how to consume and extend the module functionality.

## 🎯 Project Purpose

The primary objectives of this project are to:

- **Demonstrate Module Development**: Create a reusable, well-structured Terraform module for VPC networking
- **Showcase Module Consumption**: Illustrate how to use custom modules in real-world scenarios
- **Implement Best Practices**: Follow Terraform and AWS best practices for infrastructure as code
- **Enable Scalable Architecture**: Provide a foundation for scalable, multi-tier network architectures
- **Promote Code Reusability**: Create modular components that can be reused across different projects

## 🏗️ Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        VPC (10.0.0.0/16)                   │
│                                                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │  Public Subnet  │  │  Public Subnet  │  │ Private      │ │
│  │  (10.0.2.0/24)  │  │  (10.0.3.0/24)  │  │ Subnet       │ │
│  │  us-west-1c     │  │  us-west-1b     │  │ (10.0.1.0/24)│ │
│  │                 │  │                 │  │ us-west-1b   │ │
│  │  ┌─────────────┐│  │                 │  │              │ │
│  │  │Internet     ││  │                 │  │  ┌─────────┐ │ │
│  │  │Gateway      ││  │                 │  │  │EC2      │ │ │
│  │  │             ││  │                 │  │  │Instance │ │ │
│  │  └─────────────┘│  │                 │  │  └─────────┘ │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Component Architecture

#### Network Module (`./modules/network/`)
- **VPC Creation**: Configurable CIDR block and naming
- **Subnet Management**: Dynamic public/private subnet creation
- **Internet Connectivity**: Conditional Internet Gateway and routing
- **Multi-AZ Support**: Availability zone distribution for high availability
- **Validation**: Comprehensive input validation and error handling

#### Root Configuration
- **Module Consumption**: Demonstrates how to use the network module
- **Resource Integration**: Shows EC2 instance deployment using module outputs
- **Output Exposure**: Exposes module outputs for external consumption

## 📁 Project Structure

```
23_Project_Create_Module_VPC/
├── README.md                           # This documentation
├── main.tf                            # EC2 instance deployment example
├── networks.tf                        # Network module configuration
├── outputs.tf                         # Root-level outputs
├── versions.tf                        # Terraform and provider versions
├── .terraform.lock.hcl                # Provider version lock file
└── modules/
    └── network/                       # Custom network module
        ├── README.md                  # Module-specific documentation
        ├── LICENSE                    # MIT license for the module
        ├── vpc.tf                     # VPC and networking resources
        ├── variables.tf               # Module input variables
        ├── outputs.tf                 # Module outputs
        ├── versions.tf                # Module provider requirements
        └── examples/
            └── complete/
                └── main.tf            # Complete usage example
```

## 🚀 Getting Started

### Prerequisites

- **Terraform**: Version 1.0+ (tested with latest versions)
- **AWS CLI**: Configured with appropriate credentials
- **AWS Account**: With VPC creation permissions
- **Access**: EC2 and networking service permissions

### Quick Start

1. **Clone and Navigate**
   ```bash
   cd 23_Project_Create_Module_VPC
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

5. **View Outputs**
   ```bash
   terraform output
   ```

### Configuration Options

#### VPC Configuration
```hcl
vpc_config = {
  cidr_block = "10.0.0.0/16"
  name       = "My_Custom_VPC"
}
```

#### Subnet Configuration
```hcl
subnet_config = {
  web_subnet = {
    cidr_block = "10.0.1.0/24"
    name       = "Web Tier Subnet"
    azs        = "us-west-1a"
    public     = true
  }
  app_subnet = {
    cidr_block = "10.0.2.0/24"
    name       = "App Tier Subnet"
    azs        = "us-west-1b"
    public     = false
  }
}
```

## 🔧 Module Usage

### Basic Usage

```hcl
module "network" {
  source = "./modules/network"
  
  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "Production_VPC"
  }
  
  subnet_config = {
    public_subnet = {
      cidr_block = "10.0.1.0/24"
      name       = "Public Subnet"
      azs        = "us-west-1a"
      public     = true
    }
    private_subnet = {
      cidr_block = "10.0.2.0/24"
      name       = "Private Subnet"
      azs        = "us-west-1b"
      public     = false
    }
  }
}
```

### Advanced Usage

```hcl
module "network" {
  source = "./modules/network"
  
  vpc_config = {
    cidr_block = "172.16.0.0/16"
    name       = "Multi_Tier_VPC"
  }
  
  subnet_config = {
    web_subnet_1 = {
      cidr_block = "172.16.1.0/24"
      name       = "Web Tier AZ1"
      azs        = "us-west-1a"
      public     = true
    }
    web_subnet_2 = {
      cidr_block = "172.16.2.0/24"
      name       = "Web Tier AZ2"
      azs        = "us-west-1c"
      public     = true
    }
    app_subnet_1 = {
      cidr_block = "172.16.11.0/24"
      name       = "App Tier AZ1"
      azs        = "us-west-1a"
      public     = false
    }
    app_subnet_2 = {
      cidr_block = "172.16.12.0/24"
      name       = "App Tier AZ2"
      azs        = "us-west-1c"
      public     = false
    }
    db_subnet_1 = {
      cidr_block = "172.16.21.0/24"
      name       = "Database Tier AZ1"
      azs        = "us-west-1a"
      public     = false
    }
    db_subnet_2 = {
      cidr_block = "172.16.22.0/24"
      name       = "Database Tier AZ2"
      azs        = "us-west-1c"
      public     = false
    }
  }
}
```

## 📊 Module Outputs

The network module provides the following outputs:

| Output | Type | Description |
|--------|------|-------------|
| `vpc_id` | string | The ID of the created VPC |
| `public_subnets` | map(object) | Map of public subnets with IDs and AZs |
| `private_subnets` | map(object) | Map of private subnets with IDs and AZs |

### Output Structure

```hcl
# Public/Private subnet output structure
{
  "subnet_key" = {
    subnet_id          = "subnet-12345678"
    availability_zones = "us-west-1a"
  }
}
```

## 🔐 Security Features

### Network Security
- **Private Subnets**: No direct internet access for sensitive resources
- **Public Subnets**: Controlled internet access through Internet Gateway
- **Subnet Isolation**: Logical separation between different tiers

### Validation and Safety
- **CIDR Validation**: Ensures all CIDR blocks are properly formatted
- **AZ Validation**: Verifies availability zones exist in the target region
- **Input Validation**: Comprehensive validation of all input parameters

## 🛠️ Customization

### Adding New Subnet Types

1. **Update subnet_config** in `networks.tf`:
   ```hcl
   new_subnet = {
     cidr_block = "10.0.4.0/24"
     name       = "New Subnet"
     azs        = "us-west-1a"
     public     = false
   }
   ```

2. **Apply changes**:
   ```bash
   terraform plan
   terraform apply
   ```

### Modifying VPC Settings

1. **Update vpc_config** in `networks.tf`:
   ```hcl
   vpc_config = {
     cidr_block = "192.168.0.0/16"  # New CIDR range
     name       = "Updated_VPC_Name"
   }
   ```

2. **Update subnet CIDR blocks** to match new VPC range

## 📝 Best Practices Implemented

### Module Design
- **Single Responsibility**: Module focuses solely on networking
- **Flexible Configuration**: Supports various network topologies
- **Comprehensive Validation**: Prevents common configuration errors
- **Clear Outputs**: Provides essential information for consumers

### Terraform Patterns
- **Dynamic Resource Creation**: Uses for_each for flexible subnet creation
- **Conditional Resources**: Creates resources only when needed
- **Local Values**: Processes and transforms data efficiently
- **Lifecycle Management**: Implements preconditions for validation

### AWS Best Practices
- **Multi-AZ Deployment**: Supports high availability architectures
- **Network Segmentation**: Separates public and private resources
- **Resource Tagging**: Consistent tagging for management and cost tracking

## 🚨 Important Notes

### Known Issues
- **Duplicate Key**: There's a duplicate `subnet_2` key in `networks.tf` that should be `subnet_3`
- **AZ Constraints**: Ensure specified availability zones exist in your target region

### Limitations
- **Single Region**: Module operates within a single AWS region
- **No NAT Gateway**: Private subnets don't have outbound internet access
- **Basic Routing**: Implements basic routing patterns only

### Recommendations
- **Test First**: Always test in a development environment
- **Backup State**: Maintain Terraform state backups
- **Monitor Costs**: Track AWS costs for created resources
- **Security Groups**: Add security groups for additional protection

## 🔧 Troubleshooting

### Common Issues

**Issue**: Invalid availability zone error
```
Error: The availability zone "us-west-1d" is not available
```
**Solution**: Check available AZs in your region:
```bash
aws ec2 describe-availability-zones --region us-west-1
```

**Issue**: CIDR block overlap
```
Error: CIDR block overlaps with existing subnet
```
**Solution**: Ensure subnet CIDR blocks don't overlap and are within VPC range

**Issue**: Module not found
```
Error: Module not installed
```
**Solution**: Run `terraform init` to download and install modules

### Debugging Tips

1. **Enable Terraform Logging**:
   ```bash
   export TF_LOG=DEBUG
   terraform plan
   ```

2. **Validate Configuration**:
   ```bash
   terraform validate
   ```

3. **Check State**:
   ```bash
   terraform state list
   terraform state show <resource>
   ```

## 📚 Additional Resources

- [Terraform Module Documentation](https://www.terraform.io/docs/modules/index.html)
- [AWS VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](modules/network/LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

---

**Last Updated**: $(date)
**Terraform Version**: ~> 1.0
**AWS Provider Version**: ~> 6.0
**Tested Regions**: us-west-1, us-east-1