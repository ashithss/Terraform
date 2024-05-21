variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "enable_domain" {
  description = "Enable SES domain identity"
  type        = bool
  default     = true
}

variable "domain" {
  description = "SES Domain for identity"
  type        = string
}

variable "enable_domain_verification" {
  description = "Enable domain identity verification"
  type        = bool
  default     = true
}

variable "emails" {
  description = "List of email identities"
  type        = list(string)
  default     = []
}

variable "ses_configuration_set_name" {
  description = "Name of the SES configuration set"
  type        = string
}

variable "enable_domain_verification" {
  description = "Enable domain identity verification"
  type        = bool
  default     = true
}
