# This is used to specify the AWS region where the resources will be created
variable "aws_region" {
  description = "AWS region" # provides a brief explanation of the variable's purpose
  type = string # It specifies that the variable accepts a string value.
}

# This variable is used to define the domain name of the origin server for CloudFront
variable "origin_domain" {
  description = "Domain name of the origin for CloudFront" # It explains about the variable's purpose
  type = string # It specifies that the variable accepts a string value.
}
