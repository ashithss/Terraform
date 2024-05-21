# It represents the AWS region where the infrastructure will be provisioned.
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

# This variable defines the CIDR block for the demo1 VPC 
variable "demo1_cidr_block" {
  description = "CIDR block for demo1 VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# This variable defines the CIDR block for the demo2 VPC 
variable "demo2_cidr_block" {
  description = "CIDR block for demo2 VPC"
  type        = string
  default     = "10.1.0.0/16"
}

# This variable defines the CIDR block for the demo3 VPC 
variable "demo3_cidr_block" {
  description = "CIDR block for demo3 VPC"
  type        = string
  default     = "10.2.0.0/16"
}

# This variable represents the CIDR block for the demo1 subnet, which is a subnet within the demo1 VPC
variable "demo1_subnet_cidr_block" {
  description = "CIDR block for demo1 subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# This variable defines the Availability Zone for the demo1 subnet.
variable "demo1_subnet_availability_zone" {
  description = "Availability Zone for demo1 subnet"
  type        = string
  default     = "ap-south-1a"
}

# # This variable represents the CIDR block for the demo2 subnet, which is a subnet within the demo2 VPC
variable "demo2_subnet_cidr_block" {
  description = "CIDR block for demo2 subnet"
  type        = string
  default     = "10.1.1.0/24"
}

# This variable defines the Availability Zone for the demo2 subnet.
variable "demo2_subnet_availability_zone" {
  description = "Availability Zone for demo2 subnet"
  type        = string
  default     = "eu-north-1a"
}

# # This variable represents the CIDR block for the demo3 subnet, which is a subnet within the demo3 VPC
variable "demo3_subnet_cidr_block" {
  description = "CIDR block for demo3 subnet"
  type        = string
  default     = "10.2.1.0/24"
}

# This variable defines the Availability Zone for the demo3 subnet.
variable "demo3_subnet_availability_zone" {
  description = "Availability Zone for demo3 subnet"
  type        = string
  default     = "us-east-1a"
}
