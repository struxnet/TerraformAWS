# =============================================================================
# SECURITY GROUPS FOR RDS DATABASE ACCESS
# =============================================================================
# This file demonstrates compliant and non-compliant security group
# configurations for RDS database access. It shows best practices
# for database security through proper access control patterns.

# Source security group for application servers
# Applications that need database access should be assigned to this security group
# This enables secure, controlled access to the database
resource "aws_security_group" "allowed_sg" {
  name        = "allowed-sg"
  description = "Security group for resources allowed to access the database"
  vpc_id      = aws_vpc.db_vpc.id
}

# Compliant security group for RDS database
# Follows security best practices by only allowing access from specific security groups
# Does not allow direct IP-based access, enhancing security
resource "aws_security_group" "compliant" {
  name        = "compliant-sg"
  description = "Compliant security group for RDS database access"
  vpc_id      = aws_vpc.db_vpc.id
}

# Non-compliant security group for demonstration purposes
# Shows what NOT to do - allows broad IP-based access
# This configuration would fail security validation in the RDS module
resource "aws_security_group" "non-compliant" {
  name        = "non-compliant-sg"
  description = "Non-compliant security group demonstrating poor practices"
  vpc_id      = aws_vpc.db_vpc.id
}

# Compliant ingress rule for PostgreSQL database access
# Allows PostgreSQL traffic (port 5432) only from the allowed security group
# This is the recommended approach for database access control
resource "aws_vpc_security_group_ingress_rule" "db" {
  security_group_id            = aws_security_group.compliant.id
  referenced_security_group_id = aws_security_group.allowed_sg.id  # Source security group
  ip_protocol                  = "tcp"
  from_port                    = 5432  # PostgreSQL default port
  to_port                      = 5432
}

# Non-compliant ingress rule for demonstration purposes
# Shows poor security practice - allows HTTPS traffic from broad IP range
# This type of rule would fail RDS module security validation
resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.non-compliant.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/16"  # Overly broad access - security risk
}

