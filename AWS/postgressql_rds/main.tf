# Create an RDS DB subnet group
resource "aws_db_subnet_group" "rds-private-subnet" {
  name       = "rds-private-subnet-group"  # Set the name for the RDS DB subnet group
  subnet_ids = [var.rds_subnet1, var.rds_subnet2]  # Specify the IDs of the subnets in the subnet group
}

# Create an RDS security group
resource "aws_security_group" "rds-sg" {
  name_prefix = "my-rds-sg-"  # Set the prefix for the RDS security group name
  vpc_id      = var.vpc_id  # Specify the ID of the VPC where the security group will be created
}

# Allow ingress traffic on port 5432 for PostgreSQL
resource "aws_security_group_rule" "postgresql_inbound_access" {
  type              = "ingress"  # Set the rule type to allow ingress traffic
  from_port         = 5432  # Set the source port for inbound traffic
  to_port           = 5432  # Set the destination port for inbound traffic
  protocol          = "tcp"  # Set the protocol for inbound traffic
  cidr_blocks       = ["0.0.0.0/0"]  # Specify the CIDR blocks that are allowed to access the port
  security_group_id = aws_security_group.rds-sg.id  # Specify the ID of the RDS security group
}

# Create an RDS DB instance for PostgreSQL
resource "aws_db_instance" "my_test_postgresql" {
  allocated_storage           = var.allocated_storage  # Set the allocated storage for the RDS instance
  storage_type                = "gp2"  # Set the storage type for the RDS instance
  engine                      = "postgres"  # Set the database engine for the RDS instance
  engine_version              = var.engine_version  # Set the engine version for the RDS instance
  instance_class              = var.db_instance  # Set the instance class for the RDS instance
  name                        = "myrdstestpostgresql"  # Set the name for the RDS instance
  username                    = var.username  # Set the username for the RDS instance
  password                    = var.password  # Set the password for the RDS instance
  parameter_group_name        = "default.postgres12"  # Set the parameter group for the RDS instance
  db_subnet_group_name        = aws_db_subnet_group.rds-private-subnet.name  # Specify the name of the RDS DB subnet group
  vpc_security_group_ids      = [aws_security_group.rds-sg.id]  # Specify the IDs of the security groups for the RDS instance
  allow_major_version_upgrade = true  # Allow major version upgrades for the RDS instance
  auto_minor_version_upgrade  = true  # Enable automatic minor version upgrades for the RDS instance
  backup_retention_period     = var.backup_retention_period  # Set the backup retention period for the RDS instance
  backup_window               = var.backup_window  # Set the backup window for the RDS instance
  maintenance_window          = "Sat:00:00-Sat:03:00"  # Set the maintenance window for the RDS instance
  multi_az                    = true  # Enable multi-AZ deployment for the RDS instance
  skip_final_snapshot         = true  # Skip taking a final snapshot when deleting the RDS instance
}
