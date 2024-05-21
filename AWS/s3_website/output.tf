output "s3_bucket_name" {
  description = "Name of the created S3 bucket."
  value = aws_s3_bucket.bucket.id
}

output "s3_bucket_website_endpoint" {
  description = "Endpoint for accessing the S3 bucket website."
  value = aws_s3_bucket.bucket.website_endpoint
}