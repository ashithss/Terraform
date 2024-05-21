variable "name" {
  type        = string
  description = "(Required) Specifies the name of the virtual machine resource. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual machine."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. For a list of all Azure locations, please consult this link: https://azure.microsoft.com/en-us/regions/"
  default     = "West Europe"
}

variable "tags" {
  type        = map(any)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "kv_name" {
  description = "Azure Key Vault Name"
  type        = string
  default     = "kvTerraformRTQwpi"
}

variable "kv_enabled_for_deployment" {
  description = "Azure Key Vault Enabled for Deployment"
  type        = string
  default     = "true"
}
variable "kv_enabled_for_disk_encryption" {
  description = "Azure Key Vault Enabled for Disk Encryption"
  type        = string
  default     = "true"
}
variable "kv_enabled_for_template_deployment" {
  description = "Azure Key Vault Enabled for Deployment"
  type        = string
  default     = "true"
}
variable "kv_sku_name" {
  description = "Azure Key Vault SKU (Standard or Premium)"
  type        = string
  default     = "standard"
}

variable "kv_secret_name" {
  description = "Azure Key Vault Secret Name"
  type        = string
  default     = "TerraformSecret"
}
variable "kv_secret_value" {
  description = "Azure Key Vault Secret Value"
  type        = string
  default     = "Terraform Secret"
}