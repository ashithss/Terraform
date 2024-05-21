# Specifies the AWS provider and region.
provider "aws" {
  region = var.aws_region # Uses the region provided in the variable
}

# Creates an S3 bucket for CloudTrail logs.
resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = var.s3_bucket_name # Specifies the S3 bucket name from the variable
}

# Defines an AWS CloudTrail.
resource "aws_cloudtrail" "example" {
  name = var.cloudtrail_name # Uses the CloudTrail name from the variable
  s3_bucket_name = aws_s3_bucket.cloudtrail_bucket.id # Associates CloudTrail with the S3 bucket
  is_multi_region_trail = var.is_multi_region_trail # Uses the multi-region setting from the variable
  enable_log_file_validation = var.enable_log_file_validation # Uses log file validation setting from the variable
  include_global_service_events = var.include_global_service_events # Uses global service events setting from the variable
  enable_logging = var.enable_logging # Uses CloudTrail logging setting from the variable
}

# Defines a bucket policy for CloudTrail logs.
resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id # Specifies the target S3 bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AWSCloudTrailAclCheck20150319",
        Effect = "Allow",
        Principal = { Service = "cloudtrail.amazonaws.com" },
        Action = "s3:GetBucketAcl",
        Resource = aws_s3_bucket.cloudtrail_bucket.arn
      },
      {
        Sid = "AWSCloudTrailWrite20150319",
        Effect = "Allow",
        Principal = { Service = "cloudtrail.amazonaws.com" },
        Action = "s3:PutObject",
        Resource = "${aws_s3_bucket.cloudtrail_bucket.arn}/AWSLogs/${var.aws_account_id}/*",
        Condition = {
          StringEquals = { "s3:x-amz-acl" = "bucket-owner-full-control" }
        }
      }
    ]
  })
}
