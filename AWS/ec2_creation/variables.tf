variable "aws_region" {
  description = "AWS region for resources"
  default = "us-east-1"
}

variable "instance_ami" {
  description = "AMI ID for the instance"
  default = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  description = "Instance type for the instance"
  default = "t2.micro"
}

variable "security_group_ingress_cidr" {
  description = "CIDR block for security group ingress"
  default = "0.0.0.0/0"
}

variable "keypair_name" {
  description = "Name of the EC2 key pair"
  default = "keypair1.pem"
}

variable "volume_size" {
  description = "Size of the EBS volume in GiB"
  default = 10
}
