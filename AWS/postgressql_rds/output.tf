# Output the endpoint address of the PostgreSQL RDS instance
output "postgresql_db_endpoint" {
  description = "Endpoint address of the PostgreSQL RDS instance."
  value       = aws_db_instance.my_test_postgresql.endpoint
}

# Output the ID of the security group for the RDS instance
output "rds_security_group_id" {
  description = "ID of the security group for the RDS instance."
  value       = aws_security_group.rds-sg.id
}
