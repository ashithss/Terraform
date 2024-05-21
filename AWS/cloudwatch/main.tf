# Specifies the AWS provider configuration with the provided access key, secret key, and region.
provider "aws" {
  #access_key = var.aws_access_key # Specifies the access key for AWS authentication
  #secret_key = var.aws_secret_key # Specifies the secret key for AWS authentication
  region     = var.aws_region # Specifies the AWS region to operate in
}

# Defines an AWS CloudWatch Log Group resource.
resource "aws_cloudwatch_log_group" "my_log_group" {
  name = var.log_group_name # Specifies the name of the CloudWatch Log Group
  retention_in_days = null # Give the retention period in days & if you don't want to expire log groups the give null
  # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-5678-90ab-cdef-1234567890ab" # (Optional) Provide you KMS key 

# Defines tags for the CloudWatch Log Group resource.
  tags = {
    Name = "Mytestgroup" # Assigns a tag with the key "Name" and value "Mytestgroup" to the resource
  }
}
