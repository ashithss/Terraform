terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  /*backend "s3" {
    bucket = "sree-backend-s3"
    key    = "sree"
    region = "us-east-1"
    #dynamodb_table = "project-lock"
  }
*/
}


provider "aws" {
  region = "us-east-1"  # Specifies the AWS region to use
  #profile = "sree"  # Specifies the AWS profile to use (commented out)
  default_tags {  # Sets default tags for resources
    tags = {
      Organisation = "Self"  # Tag for organization
      Environment  = "dev"  # Tag for environment
    }
  }
}

