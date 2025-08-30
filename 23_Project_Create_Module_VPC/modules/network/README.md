# Network Module

A comprehensive Terraform module for creating AWS VPC networking infrastructure with support for public and private subnets, internet connectivity, and multi-availability zone deployments.

## Features

- ✅ **Flexible VPC Creation** - Configurable CIDR blocks and naming
- ✅ **Dynamic Subnet Management** - Support for multiple public and private subnets
- ✅ **Multi-AZ Support** - Deploy subnets across different availability zones
- ✅ **Conditional Internet Gateway** - Only created when public subnets are defined
- ✅ **Automatic Routing** - Public subnets get internet gateway routes automatically
- ✅ **Comprehensive Validation** - Input validation for CIDR blocks and availability zones
- ✅ **Structured Outputs** - Well-organized outputs for easy consumption
- ✅ **Resource Tagging** - Consistent tagging for resource management

## Usage

### Basic Example

```hcl
module \"network\" {
  source = \"./modules/network\"
  
  vpc_config = {
    cidr_block = \"10.0.0.0/16\"
    name       = \"my-vpc\"
  }
  
  subnet_config = {
    public_subnet = {
      cidr_block = \"10.0.1.0/24\"
      name       = \"Public Subnet\"
      azs        = \"us-west-1a\"
      public     = true
    }
    private_subnet = {
      cidr_block = \"10.0.2.0/24\"
      name       = \"Private Subnet\"
      azs        = \"us-west-1b\"
      public     = false
    }
  }
}
```

### Multi-Tier Architecture Example

```hcl
module \"network\" {
  source = \"./modules/network\"
  
  vpc_config = {
    cidr_block = \"172.16.0.0/16\"
    name       = \"production-vpc\"
  }
  
  subnet_config = {
    # Web tier - public subnets for load balancers
    web_subnet_1a = {
      cidr_block = \"172.16.1.0/24\"
      name       = \"Web Subnet 1A\"
      azs        = \"us-west-1a\"
      public     = true
    }
    web_subnet_1c = {
      cidr_block = \"172.16.2.0/24\"
      name       = \"Web Subnet 1C\"
      azs        = \"us-west-1c\"
      public     = true
    }
    
    # Application tier - private subnets
    app_subnet_1a = {
      cidr_block = \"172.16.11.0/24\"
      name       = \"App Subnet 1A\"
      azs        = \"us-west-1a\"
      public     = false
    }
    app_subnet_1c = {
      cidr_block = \"172.16.12.0/24\"
      name       = \"App Subnet 1C\"
      azs        = \"us-west-1c\"
      public     = false
    }
    
    # Database tier - private subnets
    db_subnet_1a = {
      cidr_block = \"172.16.21.0/24\"
      name       = \"DB Subnet 1A\"
      azs        = \"us-west-1a\"
      public     = false
    }
    db_subnet_1c = {
      cidr_block = \"172.16.22.0/24\"
      name       = \"DB Subnet 1C\"
      azs        = \"us-west-1c\"
      public     = false
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 6.0 |

## Resources

This module creates the following AWS resources:

| Resource | Type | Conditional |
|----------|------|-------------|
| `aws_vpc.this` | VPC | Always |
| `aws_subnet.this` | Subnet | Per subnet config |
| `aws_internet_gateway.this` | Internet Gateway | Only if public subnets exist |
| `aws_route_table.public_rtb` | Route Table | Only if public subnets exist |
| `aws_route_table_association.public` | Route Table Association | Per public subnet |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_config | Configuration object for VPC creation | `object({name=string, cidr_block=string})` | n/a | yes |
| subnet_config | Map of subnet configurations | `map(object({cidr_block=string, name=string, azs=string, public=optional(bool,false)}))` | n/a | yes |

### Input Details

#### vpc_config

```hcl
vpc_config = {
  name       = \"string\"  # Human-readable name for the VPC
  cidr_block = \"string\"  # CIDR block for the VPC (e.g., \"10.0.0.0/16\")
}
```

#### subnet_config

```hcl
subnet_config = {
  \"subnet_key\" = {
    cidr_block = \"string\"           # CIDR block for the subnet (e.g., \"10.0.1.0/24\")
    name       = \"string\"           # Human-readable name for the subnet
    azs        = \"string\"           # Availability zone (e.g., \"us-west-1a\")
    public     = bool               # Optional: true for public, false for private (default: false)
  }
}
```

## Outputs

| Name | Description | Type |
|------|-------------|------|
| vpc_id | The ID of the VPC | `string` |
| public_subnets | Map of public subnets with their IDs and availability zones | `map(object({subnet_id=string, availability_zones=string}))` |
| private_subnets | Map of private subnets with their IDs and availability zones | `map(object({subnet_id=string, availability_zones=string}))` |

### Output Examples

```hcl
# vpc_id output
\"vpc-1234567890abcdef0\"

# public_subnets output
{
  \"web_subnet\" = {
    subnet_id          = \"subnet-1234567890abcdef0\"
    availability_zones = \"us-west-1a\"
  }
}

# private_subnets output
{
  \"app_subnet\" = {
    subnet_id          = \"subnet-0987654321fedcba0\"
    availability_zones = \"us-west-1b\"
  }
}
```

## Validation Rules

The module includes comprehensive validation to prevent common configuration errors:

### VPC CIDR Validation
- Ensures the VPC CIDR block is valid CIDR notation
- Example valid values: `\"10.0.0.0/16\"`, `\"172.16.0.0/12\"`, `\"192.168.0.0/16\"`

### Subnet CIDR Validation
- Validates all subnet CIDR blocks are in proper CIDR notation
- Subnet CIDR blocks should be subsets of the VPC CIDR block

### Availability Zone Validation
- Verifies that specified availability zones exist in the current AWS region
- Provides detailed error messages with available AZs if validation fails

## Architecture Patterns

### Public-Private Architecture
```
VPC (10.0.0.0/16)
├── Public Subnet (10.0.1.0/24) - us-west-1a
│   ├── Internet Gateway
│   └── Route to 0.0.0.0/0 → IGW
└── Private Subnet (10.0.2.0/24) - us-west-1b
    └── No direct internet access
```

### Multi-AZ High Availability
```
VPC (172.16.0.0/16)
├── Public Subnet 1A (172.16.1.0/24) - us-west-1a
├── Public Subnet 1C (172.16.2.0/24) - us-west-1c
├── Private Subnet 1A (172.16.11.0/24) - us-west-1a
└── Private Subnet 1C (172.16.12.0/24) - us-west-1c
```

## Advanced Features

### Conditional Resource Creation
The module intelligently creates resources only when needed:
- **Internet Gateway**: Only created if public subnets are defined
- **Public Route Table**: Only created if public subnets exist
- **Route Table Associations**: Only created for public subnets

### Dynamic Subnet Processing
The module automatically categorizes subnets:
- Separates public and private subnets using local values
- Processes each type differently for appropriate routing
- Enables flexible subnet configurations

### Comprehensive Error Handling
- **Precondition Checks**: Validates availability zones before resource creation
- **Detailed Error Messages**: Provides actionable error information
- **Input Validation**: Prevents invalid configurations at plan time

## Best Practices

### CIDR Block Planning
```hcl
# Good: Non-overlapping subnets within VPC range
vpc_config = {
  cidr_block = \"10.0.0.0/16\"  # 65,536 IPs
}

subnet_config = {
  public_subnet = {
    cidr_block = \"10.0.1.0/24\"   # 256 IPs
  }
  private_subnet = {
    cidr_block = \"10.0.2.0/24\"   # 256 IPs
  }
}
```

### Multi-AZ Deployment
```hcl
# Good: Distribute subnets across multiple AZs
subnet_config = {
  public_1a = {
    azs = \"us-west-1a\"
  }
  public_1c = {
    azs = \"us-west-1c\"
  }
  private_1a = {
    azs = \"us-west-1a\"
  }
  private_1c = {
    azs = \"us-west-1c\"
  }
}
```

### Naming Conventions
```hcl
# Good: Descriptive, consistent naming
vpc_config = {
  name = \"production-vpc\"
}

subnet_config = {
  web_subnet_1a = {
    name = \"Web Tier Subnet 1A\"
  }
  app_subnet_1a = {
    name = \"App Tier Subnet 1A\"
  }
}
```

## Troubleshooting

### Common Issues

#### Invalid Availability Zone
```
Error: The availability zone \"us-west-1d\" is not available in the current region.
```
**Solution**: Check available AZs in your region:
```bash
aws ec2 describe-availability-zones --region us-west-1 --query 'AvailabilityZones[].ZoneName'
```

#### CIDR Block Validation Error
```
Error: The vpc_cidr must be a valid CIDR block.
```
**Solution**: Ensure CIDR blocks follow proper notation:
- Valid: `\"10.0.0.0/16\"`, `\"172.16.0.0/12\"`
- Invalid: `\"10.0.0.0\"`, `\"10.0.0.0/33\"`

#### Subnet CIDR Outside VPC Range
```
Error: Subnet CIDR block is outside VPC CIDR range.
```
**Solution**: Ensure subnet CIDR blocks are subsets of the VPC CIDR:
```hcl
# VPC: 10.0.0.0/16 (10.0.0.0 - 10.0.255.255)
# Valid subnet: 10.0.1.0/24 (10.0.1.0 - 10.0.1.255)
# Invalid subnet: 192.168.1.0/24 (outside VPC range)
```

### Debugging Tips

1. **Enable Terraform Debug Logging**:
   ```bash
   export TF_LOG=DEBUG
   terraform plan
   ```

2. **Validate Configuration**:
   ```bash
   terraform validate
   ```

3. **Check Available AZs**:
   ```bash
   aws ec2 describe-availability-zones --region <your-region>
   ```

## Examples

See the [examples/complete](examples/complete/) directory for a complete working example.

## Contributing

Contributions are welcome! Please ensure that:
1. All code is properly formatted (`terraform fmt`)
2. Configuration is valid (`terraform validate`)
3. Documentation is updated for any changes
4. Examples are provided for new features

## License

This module is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

### v1.0.0
- Initial release
- Support for VPC creation with custom CIDR blocks
- Dynamic public and private subnet creation
- Multi-AZ support
- Comprehensive validation and error handling
- Structured outputs for easy consumption

---

**Module Version**: 1.0.0  
**Terraform Version**: >= 1.0  
**AWS Provider Version**: ~> 6.0  
**Last Updated**: $(date)