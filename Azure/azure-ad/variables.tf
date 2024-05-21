variable "num" {
  type        = number
  description = "Number of days to add to the base timestamp to configure the rotation timestamp. When the current time has passed the rotation timestamp, the resource will trigger recreation. At least one of the 'rotation_' arguments must be configured."
}

variable "enable" {
  type        = bool
  description = "Optional) Determines if the app role is enabled. Defaults to true."
  default = true
}
