# # Variable to store the AWS Access Key for authentication.
# variable "aws_access_key" {
#   description = "AWS Access Key" # Describes the purpose of this variable
# }

# # Variable to store the AWS Secret Key for authentication.
# variable "aws_secret_key" {
#   description = "AWS Secret Key" # Describes the purpose of this variable
# }

# Variable to store the AWS Region.
variable "aws_region" {
  description = "AWS Region" # Describes the purpose of this variable
  default     = "ap-south-1" # Specifies the default AWS region, which can be changed
}

# Variable to store the name of the CloudWatch Log Group.
variable "log_group_name" {
  description = "log_group_name" # Describes the purpose of this variable
}
