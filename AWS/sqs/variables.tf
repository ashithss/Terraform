variable "queue_name" {
  description = "Name of the SQS queue"
  type        = string
}

variable "enable_dead_letter_queue" {
  description = "Enable dead-letter queue?"
  type        = bool
  default     = false
}
