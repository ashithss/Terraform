provider "aws" {
  region = var.region  # AWS region
}

resource "aws_vpc" "demo1_vpc" {
  # Creates a demo1 VPC
  cidr_block           = var.demo1_cidr_block  # CIDR block for demo1 VPC
  enable_dns_hostnames = true  # Enable DNS hostnames
  enable_dns_support   = true  # Enable DNS support
  tags = {
    Name = "demo1 VPC"
  }
}

resource "aws_vpc" "demo2_vpc" {
  # Creates a demo2 VPC
  cidr_block           = var.demo2_cidr_block  # CIDR block for demo2 VPC
  enable_dns_hostnames = true  # Enable DNS hostnames
  enable_dns_support   = true  # Enable DNS support
  tags = {
    Name = "demo2 VPC"
  }
}

resource "aws_vpc" "demo3_vpc" {
  # Creates a demo3 VPC
  cidr_block           = var.demo3_cidr_block  # CIDR block for demo3 VPC
  enable_dns_hostnames = true  # Enable DNS hostnames
  enable_dns_support   = true  # Enable DNS support
  tags = {
    Name = "demo3 VPC"
  }
}

resource "aws_ec2_transit_gateway" "transit_gateway" {
  # Creates a Transit Gateway
  description = "Transit Gateway"  # Description for the Transit Gateway
  tags = {
    Name = "Transit Gateway"
  }
}

resource "aws_subnet" "demo1_subnet" {
  # Creates a demo1 Subnet
  vpc_id                  = aws_vpc.demo1_vpc.id
  cidr_block              = var.demo1_subnet_cidr_block  # CIDR block for demo1 Subnet
  availability_zone       = "ap-south-1a"  # Update the availability zone here
  map_public_ip_on_launch = true  # Map public IP on launch

  tags = {
    Name = "demo1 Subnet"
  }
}

resource "aws_subnet" "demo2_subnet" {
  # Creates a demo2 Subnet
  vpc_id                  = aws_vpc.demo2_vpc.id
  cidr_block              = var.demo2_subnet_cidr_block  # CIDR block for demo2 Subnet
  availability_zone       = "ap-south-1b"  # Update the availability zone here
  map_public_ip_on_launch = true  # Map public IP on launch

  tags = {
    Name = "demo2 Subnet"
  }
}

resource "aws_subnet" "demo3_subnet" {
  # Creates a demo3 Subnet
  vpc_id                  = aws_vpc.demo3_vpc.id
  cidr_block              = var.demo3_subnet_cidr_block  # CIDR block for demo3 Subnet
  availability_zone       = "ap-south-1c"  # Update the availability zone here
  map_public_ip_on_launch = true  # Map public IP on launch

  tags = {
    Name = "demo3 Subnet"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "demo1_attachment" {
  # Attaches demo1 VPC to the Transit Gateway
  transit_gateway_id = aws_ec2_transit_gateway.transit_gateway.id
  vpc_id             = aws_vpc.demo1_vpc.id
  subnet_ids         = [aws_subnet.demo1_subnet.id]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "demo2_attachment" {
  # Attaches demo2 VPC to the Transit Gateway
  transit_gateway_id = aws_ec2_transit_gateway.transit_gateway.id
  vpc_id             = aws_vpc.demo2_vpc.id
  subnet_ids         = [aws_subnet.demo2_subnet.id]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "demo3_attachment" {
  # Attaches demo3 VPC to the Transit Gateway
  transit_gateway_id = aws_ec2_transit_gateway.transit_gateway.id
  vpc_id             = aws_vpc.demo3_vpc.id
  subnet_ids         = [aws_subnet.demo3_subnet.id]
}
