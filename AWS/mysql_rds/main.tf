# Create an RDS subnet group for private subnets
resource "aws_db_subnet_group" "rds-private-subnet" {
  name       = "rds-private-subnet-group"  # Set the name for the RDS subnet group
  subnet_ids = ["${var.rds_subnet1}","${var.rds_subnet2}"]  # Specify the IDs of the private subnets
}

# Create a security group for RDS
resource "aws_security_group" "rds-sg" {
  name   = "my-rds-sg"  # Set the name for the RDS security group
  vpc_id  = "${var.vpc_id}"  # Specify the ID of the VPC where the security group will be created
}

# Allow ingress access on port 3306 for MySQL
resource "aws_security_group_rule" "mysql_inbound_access" {
  from_port         = 3306  # Set the source port for inbound traffic
  protocol          = "tcp"  # Set the protocol for inbound traffic
  security_group_id = "${aws_security_group.rds-sg.id}"  # Specify the ID of the RDS security group
  to_port           = 3306  # Set the destination port for inbound traffic
  type              = "ingress"  # Set the rule type to allow ingress traffic
  cidr_blocks       = ["0.0.0.0/0"]  # Specify the CIDR blocks that are allowed to access the port
}

# Create an RDS MySQL instance
resource "aws_db_instance" "my_test_mysql" {
  allocated_storage           = var.allocated_storage  # Set the allocated storage for the RDS instance
  storage_type                = "gp2"  # Set the storage type for the RDS instance
  engine                      = "mysql"  # Set the database engine for the RDS instance
  engine_version              = var.engine_version  # Set the engine version for the RDS instance
  instance_class              = "${var.db_instance}"  # Set the instance class for the RDS instance
  name                        = "myrdstestmysql"  # Set the name for the RDS instance
  username                    = var.username  # Set the username for the RDS instance
  password                    = var.password  # Set the password for the RDS instance
  parameter_group_name        = "default.mysql5.7"  # Set the parameter group for the RDS instance
  db_subnet_group_name        = "${aws_db_subnet_group.rds-private-subnet.name}"  # Specify the name of the RDS subnet group
  vpc_security_group_ids      = ["${aws_security_group.rds-sg.id}"]  # Specify the IDs of the security groups for the RDS instance
  allow_major_version_upgrade = true  # Allow major version upgrades for the RDS instance
  auto_minor_version_upgrade  = true  # Enable automatic minor version upgrades for the RDS instance
  backup_retention_period     = var.backup_retention_period  # Set the backup retention period for the RDS instance
  backup_window               = var.backup_window  # Set the backup window for the RDS instance
  maintenance_window          = "Sat:00:00-Sat:03:00"  # Set the maintenance window for the RDS instance
  multi_az                    = true  # Enable multi-AZ deployment for the RDS instance
  skip_final_snapshot         = true  # Skip taking a final snapshot when deleting the RDS instance
}
