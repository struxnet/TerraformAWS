output "rds_instance_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = module.database.rds_instance_endpoint
}