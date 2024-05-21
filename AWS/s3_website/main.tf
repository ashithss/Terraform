# Before working with this script, please go through the README.md file for better understanding

# Create an S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket_prefix = var.bucket_prefix  # Set the bucket prefix using a variable
}

# Configure block public access for the bucket
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls   = false  # Allow public ACLs for the bucket
  block_public_policy = false  # Allow public bucket policies
}

# Configure a bucket policy to make it public for website hosting
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"
    }
  ]
}
EOF
}

# Configure S3 website hosting for the bucket
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"  # Set the index document for the website
  }

  error_document {
    key = "error.html"  # Set the error document for the website
  }
}

# Upload website files to the S3 bucket
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id

  # Upload each file in the "uploads/" directory
  for_each     = fileset("uploads/", "*")
  key          = "website/${each.value}"  # Set the key (path) for each uploaded file
  source       = "uploads/${each.value}"  # Set the source path for each uploaded file
  etag         = filemd5("uploads/${each.value}")  # Calculate the MD5 checksum of each uploaded file
  content_type = "text/html"  # Set the content type of each uploaded file

  depends_on = [
    aws_s3_bucket.bucket  # Ensure the bucket is created before uploading files
  ]
}
