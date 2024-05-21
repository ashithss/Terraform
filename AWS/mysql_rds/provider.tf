# Declare the required AWS provider and its version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }
}

# Configure the AWS provider with the specified region
provider "aws" {
  region = var.aws_region  # Set the AWS region based on the value of the `aws_region` variable
}
