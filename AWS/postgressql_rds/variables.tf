variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "rds_subnet1" {
  description = "List of subnet IDs for the DB Db subnet group."
  type        = string
  default     = "subnet-05b1e4eb1345120aa"
}

variable "rds_subnet2" {
  description = "List of subnet IDs for the DB Db subnet group."
  type        = string
  default     = "subnet-0d78b00ecc64088e2"
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
  default     = "vpc-0e54585d1c94c3e51" 
}

variable "db_instance" {
  description = "Instance class for the DB instance."
  type        = string
  default     = "db.t2.micro"
}

variable "allocated_storage" {
  description = "The amount of allocated storage for the DB instance, in gigabytes."
  type        = number
  default     = 20
}

variable "engine_version" {
  description = "DB engine version for MySQL."
  type        = string
  default     = "5.7"
}

variable "username" {
  description = "Username for the DB instance."
  type        = string
  default     = "admin"
}

variable "password" {
  description = "Password for the DB instance."
  type        = string
  default     = "admin123"
}

variable "backup_retention_period" {
  description = "The number of days for which automated backups are retained."
  type        = number
  default     = 35
}

variable "backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled."
  type        = string
  default     = "22:00-23:00"
}