terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"  # Specifies the source of the AWS provider plugin
      version = "~> 5.0"  # Specifies the required version of the AWS provider plugin
    }
  }
}

provider "aws" {
  region = var.aws_region  # Specifies the AWS region using the value of the `aws_region` variable
}

locals {
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]  # Defines a list of availability zones based on the `aws_region` variable
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr  # Specifies the CIDR block for the VPC using the `vpc_cidr` variable
  enable_dns_hostnames = true  # Enables DNS hostnames for the VPC
  enable_dns_support   = true  # Enables DNS support for the VPC

  tags = {
    Name        = "${var.environment}-vpc"  # Sets the Name tag for the VPC based on the `environment` variable
    Environment = var.environment  # Sets the Environment tag for the VPC using the `environment` variable
  }
}

# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id  # Associates the public subnet with the VPC
  count                   = length(var.public_subnets_cidr)  # Creates multiple subnets based on the length of the `public_subnets_cidr` variable
  cidr_block              = element(var.public_subnets_cidr, count.index)  # Specifies the CIDR block for each public subnet based on the `public_subnets_cidr` variable
  availability_zone       = element(local.availability_zones, count.index)  # Assigns an availability zone to each public subnet based on the `availability_zones` variable
  map_public_ip_on_launch = true  # Automatically assigns public IP addresses to instances launched in the subnet

  tags = {
    Name        = "${var.environment}-${element(local.availability_zones, count.index)}-public-subnet"  # Sets the Name tag for each public subnet based on the `environment` and `availability_zones` variables
    Environment = "${var.environment}"  # Sets the Environment tag for each public subnet using the `environment` variable
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id  # Associates the private subnet with the VPC
  count                   = length(var.private_subnets_cidr)  # Creates multiple subnets based on the length of the `private_subnets_cidr` variable
  cidr_block              = element(var.private_subnets_cidr, count.index)  # Specifies the CIDR block for each private subnet based on the `private_subnets_cidr` variable
  availability_zone       = element(local.availability_zones, count.index)  # Assigns an availability zone to each private subnet based on the `availability_zones` variable
  map_public_ip_on_launch = false  # Disables automatic assignment of public IP addresses to instances launched in the subnet

  tags = {
    Name        = "${var.environment}-${element(local.availability_zones, count.index)}-private-subnet"  # Sets the Name tag for each private subnet based on the `environment` and `availability_zones` variables
    Environment = "${var.environment}"  # Sets the Environment tag for each private subnet using the `environment` variable
  }
}

# Internet gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id  # Associates the internet gateway with the VPC

  tags = {
    "Name"        = "${var.environment}-igw"  # Sets the Name tag for the internet gateway based on the `environment` variable
    "Environment" = var.environment  # Sets the Environment tag for the internet gateway using the `environment` variable
  }
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true  # Specifies that the Elastic IP is associated with a VPC
  depends_on = [aws_internet_gateway.ig]  # Ensures that the Elastic IP is created after the internet gateway

  # No tags are specified for the Elastic IP
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id  # Associates the Elastic IP with the NAT gateway
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)  # Specifies the subnet for the NAT gateway based on the first public subnetin the list of public subnets
  tags = {
    Name        = "nat-gateway-${var.environment}"  # Sets the Name tag for the NAT gateway based on the `environment` variable
    Environment = "${var.environment}"  # Sets the Environment tag for the NAT gateway using the `environment` variable
  }
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id  # Associates the routing table with the VPC

  tags = {
    Name        = "${var.environment}-private-route-table"  # Sets the Name tag for the routing table based on the `environment` variable
    Environment = "${var.environment}"  # Sets the Environment tag for the routing table using the `environment` variable
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id  # Associates the routing table with the VPC

  tags = {
    Name        = "${var.environment}-public-route-table"  # Sets the Name tag for the routing table based on the `environment` variable
    Environment = "${var.environment}"  # Sets the Environment tag for the routing table using the `environment` variable
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id  # Associates the route with the public routing table
  destination_cidr_block = "0.0.0.0/0"  # Specifies the destination CIDR block for the route
  gateway_id             = aws_internet_gateway.ig.id  # Specifies the internet gateway as the target for the route
}

# Route for NAT Gateway
resource "aws_route" "private_internet_gateway" {
  route_table_id         = aws_route_table.private.id  # Associates the route with the private routing table
  destination_cidr_block = "0.0.0.0/0"  # Specifies the destination CIDR block for the route
  gateway_id             = aws_nat_gateway.nat.id  # Specifies the NAT gateway as the target for the route
}

# Route table associations for both Public & Private Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)  # Creates multiple route table associations based on the length of the `public_subnets_cidr` variable
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)  # Associates each public subnet with the corresponding route table
  route_table_id = aws_route_table.public.id  # Associates the public route table with the route table association
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)  # Creates multiple route table associations based on the length of the `private_subnets_cidr` variable
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)  # Associates each private subnet with the corresponding route table
  route_table_id = aws_route_table.private.id  # Associates the private route table with the route table association
}
