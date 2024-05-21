# Defines the AWS region where the resources will be provisioned.
variable "aws_region" {
  description = "AWS region" # Describes the purpose of this variable
  type = string # Specifies the data type of the variable
}

# Defines the name of the S3 bucket to be used for CloudTrail logs.
variable "s3_bucket_name" {
  description = "Name of the S3 bucket for CloudTrail" # Describes the purpose of this variable
  type = string # Specifies the data type of the variable
}

# Defines the name of the CloudTrail trail.
variable "cloudtrail_name" {
  description = "Name of the CloudTrail trail" # Describes the purpose of this variable
  type = string # Specifies the data type of the variable
}

# Specifies whether the CloudTrail trail is multi-region.
variable "is_multi_region_trail" {
  description = "Enable multi-region trail" # Describes the purpose of this variable
  type = bool # Specifies the data type of the variable
}

# Specifies whether log file validation is enabled.
variable "enable_log_file_validation" {
  description = "Enable log file validation" # Describes the purpose of this variable
  type = bool # Specifies the data type of the variable
}

# Specifies whether global service events are included in CloudTrail.
variable "include_global_service_events" {
  description = "Include global service events" # Describes the purpose of this variable
  type = bool # Specifies the data type of the variable
}

# Specifies whether logging is enabled for the CloudTrail trail.
variable "enable_logging" {
  description = "Enable logging for the CloudTrail trail" # Describes the purpose of this variable
  type = bool # Specifies the data type of the variable
}

# Specifies the AWS account ID.
variable "aws_account_id" {
  description = "AWS account ID" # Describes the purpose of this variable
  type = string # Specifies the data type of the variable
}
