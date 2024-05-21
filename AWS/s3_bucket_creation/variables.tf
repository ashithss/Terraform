variable "region" {
  type        = string
  description = "The region to create/manage resources in"
  default     = "us-east-1"
}

variable "bucket_prefix" {
  type        = string
  description = "The prefix to use for the S3 bucket name"
  default     = "tf-bucket"
}