# Configure the AWS provider with the specified region
provider "aws" {
  region = var.region
}

# Generate a random password
resource "random_password" "password" {
  length           = 16     # The length of the password
  special          = true   # Include special characters in the password
  override_special = "_%@"  # Specify additional special characters to include in the password
}

# Create an AWS VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr  # The CIDR block for the VPC
}

# Create two AWS subnets within the VPC
resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.main.id  # The ID of the VPC
  cidr_block = var.subnet_cidr_1  # The CIDR block for subnet 1
}

resource "aws_subnet" "subnet_2" {
  vpc_id     = aws_vpc.main.id  # The ID of the VPC
  cidr_block = var.subnet_cidr_2  # The CIDR block for subnet 2
}

# Create an AWS RDS DB subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = var.db_subnet_group_name  # The name of the DB subnet group
  description = "My DB Subnet Group"  # The description of the DB subnet group

  subnet_ids = [
    aws_subnet.subnet_1.id,  # Subnet 1 ID
    aws_subnet.subnet_2.id,  # Subnet 2 ID
  ]
}

# Create an AWS RDS cluster
resource "aws_rds_cluster" "main" {
  cluster_identifier   = var.cluster_identifier  # The cluster identifier
  database_name        = var.database_name  # The name of the database
  master_username      = random_password.password.result  # The master username
  master_password      = random_password.password.result  # The master password
  port                 = 5432  # The port number
  engine               = "aurora-postgresql"  # The database engine
  engine_version       = "14"  # The engine version
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name  # The name of the DB subnet group
  storage_encrypted    = true  # Enable storage encryption
}

# Create AWS RDS cluster instances
resource "aws_rds_cluster_instance" "main" {
  count                  = var.instance_count  # The number of instances to create
  identifier             = "myinstance-${count.index + 1}"  # The identifier for each instance
  cluster_identifier     = aws_rds_cluster.main.id  # The ID of the RDS cluster
  instance_class         = "db.r4.large"  # The instance type
  engine                 = "aurora-postgresql"  # The database engine
  engine_version         = "14"  # The engine version
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name  # The name of the DB subnet group
  publicly_accessible   = true  # Make the instances publicly accessible
}

# Define local variables for the database credentials
locals {
  db_creds = {
    username = random_password.password.result  # The randomly generated username
    password = random_password.password.result  # The randomly generated password
  }
}
