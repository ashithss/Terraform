# # Terraform version
# terraform {
#   required_version = ">= 1.3.6"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 4.48.0"
#     }
#   }
# }

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }
}

provider "aws" {
  region     = "us-west-2"
  access_key = ""
  secret_key = ""
}