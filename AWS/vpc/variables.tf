variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment name for tagging resources."
  type        = string
  default     = "javatodev"
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "CIDR blocks for Public Subnets."
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.128.0/20"]
}

variable "private_subnets_cidr" {
  description = "CIDR blocks for Private Subnets."
  type        = list(string)
  default     = ["10.0.16.0/20", "10.0.144.0/20"]
}

