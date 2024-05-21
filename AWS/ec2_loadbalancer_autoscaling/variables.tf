variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "instance_ami" {
  description = "The ID of the EC2 instance AMI."
  type        = string
  default = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  description = "The type of EC2 instance."
  type        = string
  default     = "t2.micro"
}

variable "subnets" {
  description = "List of subnet IDs for the load balancer and instances."
  type        = list(string)
  default     = ["subnet-05b1e4eb1345120aa", "subnet-0d78b00ecc64088e2"]
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
  default     = "vpc-0e54585d1c94c3e51" 
}

variable "min_instances" {
  description = "Minimum number of instances in the Auto Scaling group."
  type        = number
  default     = 2
}

variable "max_instances" {
  description = "Maximum number of instances in the Auto Scaling group."
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling group."
  type        = number
  default     = 2
}