module "vpc" {
  source         = "terraform-aws-modules/vpc/aws"  # Specifies the source of the VPC module
  version        = "5.1.1"  # Specifies the version of the VPC module

  name           = "test_ecs_provisioning"  # Name of the VPC
  cidr           = "10.0.0.0/16"  # CIDR block for the VPC
  azs            = ["us-east-1a", "us-east-1b", "us-east-1c"]  # Availability Zones for the VPC
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]  # CIDR blocks for public subnets

  tags = {  # Tags to assign to the VPC resources
    "env"       = "dev"
    "createdBy" = "binpipe"
  }
}

data "aws_vpc" "main" {
  id = module.vpc.vpc_id
}
