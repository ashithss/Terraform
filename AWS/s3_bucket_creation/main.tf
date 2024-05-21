# Create an S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket_prefix       = var.bucket_prefix  # Set the bucket prefix using a variable
  object_lock_enabled = true  # Enable object lock for the bucket

  tags = {
    "Project" = "Testing"  # Assign tags to the bucket
  }
}

# Configure Object Lock for the bucket
resource "aws_s3_bucket_object_lock_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.bucket  # Reference the bucket created above

  # Configure a default retention rule for object lock
  rule {
    default_retention {
      mode = "COMPLIANCE"  # Set the object lock mode to "COMPLIANCE"
      days = 5  # Specify the number of days for retention
    }
  }
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id  # Reference the bucket created above

  versioning_configuration {
    status = "Enabled"  # Enable versioning for the bucket
  }
}

# Create an object in the bucket
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id  # Reference the bucket created above

  # Create an object for each file in the "uploads/" directory
  for_each = fileset("uploads/", "*")
  key      = each.value  # Set the key (filename) for the object
  source   = "uploads/${each.value}"  # Set the source path for the object
  etag     = filemd5("uploads/${each.value}")  # Calculate the MD5 checksum of the file

  depends_on = [
    aws_s3_bucket.bucket  # Ensure the bucket is created before creating the object
  ]
}

# Configure block public access for the bucket
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.bucket.id  # Reference the bucket created above

  block_public_acls   = true  # Block public ACLs for the bucket
  block_public_policy = true  # Block public bucket policies
}
