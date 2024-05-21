output "ses_domain_identity" {
  description = "SES domain identity"
  value       = aws_ses_domain_identity.default[0].domain
}

output "ses_configuration_set_name" {
  description = "Name of the SES configuration set"
  value       = aws_ses_configuration_set.default.name
}
