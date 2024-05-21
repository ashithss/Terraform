# Configure the AWS provider with the specified region
provider "aws" {
  region = var.region
}

# Define an AWS ACM certificate
resource "aws_acm_certificate" "main" {
  domain_name       = var.domain_name  # The domain name for the certificate
  validation_method = "DNS"            # The validation method for the certificate

  lifecycle {
    create_before_destroy = true  # Create the new certificate before destroying the old one
  }
}

# Define an AWS Route 53 zone
resource "aws_route53_zone" "main" {
  name = var.route53_domain_name  # The name of the Route 53 zone
}

# Validate the ACM certificate using DNS validation
resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn  # The ARN of the ACM certificate
  validation_record_fqdns = [for opt in aws_acm_certificate.main.domain_validation_options : opt.resource_record_name]  # The fully qualified domain names (FQDNs) for DNS validation
}

# Create Route 53 records for ACM certificate validation
resource "aws_route53_record" "acm_validation" {
  count   = length(aws_acm_certificate.main.domain_validation_options)  # Create a record for each domain validation option
  zone_id = aws_route53_zone.main.zone_id  # The ID of the Route 53 zone
  name    = element(aws_acm_certificate.main.domain_validation_options.*.resource_record_name, count.index)  # The name of the record
  type    = element(aws_acm_certificate.main.domain_validation_options.*.resource_record_type, count.index)  # The type of the record
  ttl     = 300  # The time to live (TTL) for the record
  records = [element(aws_acm_certificate.main.domain_validation_options.*.resource_record_value, count.index)]  # The record value
}
