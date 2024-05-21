terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"    # Specifies the source and version of the AWS provider
      version = "4.64.0"           # Specifies the required version of the AWS provider
    }
  }

  backend "s3" {
    bucket = "<s3-bucket_name>"# Specifies the name of the S3 bucket for storing Terraform state
    key    = "<key>"           # Specifies the key (path) within the bucket to store the state file
    region = "<region>"        # Specifies the AWS region where the S3 bucket is located
    #dynamodb_table = "project-lock"  # Optional: Specifies the name of the DynamoDB table for state locking
  }
}

provider "aws" {
  # Configuration options for the AWS provider
  region = "<region>"         # Specifies the default AWS region for resource provisioning
  #profile = "sree"           # Optional: Specifies the AWS profile to use for authentication
}
