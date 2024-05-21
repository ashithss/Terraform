terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.64.0"
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
  region = var.location
}