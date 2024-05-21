# This block specifies the provider for the AWSresources being used.
provider "aws" {
  region = var.aws_region # It sets the region to the value provided in the `var.aws_region` variable
}

# This block defines an AWS CloudFront distribution resource named "my_distribution"
resource "aws_cloudfront_distribution" "my_distribution" {
  enabled = true # This indicates that the distribution should be enabled
  is_ipv6_enabled = true # This parameter set to `true` to enable IPv6 support for the distribution.

# The `origin` block specifies the origin server for delivering content
  origin {
    domain_name = var.origin_domain # Its the value provided in the `var.origin_domain` variable
    origin_id   = "my-origin-id" # The `origin_id` parameter is a unique identifier for the origin
  }

# This block configures the default cache behavior for the CloudFront distribution.
  default_cache_behavior {
    target_origin_id       = "my-origin-id" # This parameter specifies the ID of the origin server.
    viewer_protocol_policy = "allow-all" # This will be allowing both HTTP and HTTPS access
    allowed_methods        = ["GET", "HEAD", "OPTIONS"] # This parameter lists the methods allowed
    cached_methods         = ["GET", "HEAD"] # This specifies which methods should be cached.

# block defines how CloudFront handles forwarded values from the viewer to the origin server.
    forwarded_values {
      query_string = false  # It is set to `false` to exclude the query string from being forwarded
      cookies {
        forward = "none" # It specifies that no cookies should be forwarded
      }
    }
  }

# This block configures any restrictions on accessing the CloudFront distribution
  restrictions {
    geo_restriction {
      restriction_type = "none" # This indicates that there are no restrictions based on geographic locations.
    }
  }

# This block specifies the SSL/TLS certificate used for secure communication between viewers and CloudFront
  viewer_certificate {
    cloudfront_default_certificate = true # it indicates that the CloudFront default certificate should be used.
  }
}
