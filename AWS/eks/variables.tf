# This variable is used to specify the AWS region where the resources will be created
variable "location" {
  default = "<region>"
}

# This variable is used to specify the Amazon Machine Image (AMI) ID for the EC2 instance
variable "os_name" {
  default = "<ami_id>"
}

# This variable is used to specify the key pair name for accessing the EC2 instance
variable "key" {
  default = "<key_name>"
}

# This variable is used to specify the instance type for the EC2 instance
variable "instance-type" {
  default = "<instance_type>"
}

# This variable is used to specify the CIDR block for the VPC
variable "vpc-cidr" {
  default = "10.10.0.0/16"  
}

# This variable is used to specify the CIDR block for subnet 1
variable "subnet1-cidr" {
  default = "10.10.1.0/24"
}

# This variable is used to specify the CIDR block for subnet 2
variable "subnet2-cidr" {
  default = "10.10.2.0/24"
}

# This variable is used to specify the availability zone for subnet 1
variable "subent_az" {
  default =  "ap-south-1a"  
}

# This variable is used to specify the availability zone for subnet 2
variable "subent-2_az" {
  default =  "ap-south-1b"  
}
