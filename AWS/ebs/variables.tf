variable "availability_zone" {
    description = "Availability zone to provision the volume in."
    type = string
}

variable "encrypted" {
    description = "Whether to encrypt the volume."
    type = bool
    default = false
}

variable "iops" {
    description = "IOPS to provision."
    type = number
    default = null
}

variable "size" {
    description = "Size of drive in GiBs."
    type = number
}

variable "snapshot_id" {
    description = "Snapshot to base the volume off of."
    type = string
    default = null
}

variable "volume_type" {
    description = "Volume type."
    type = string
    default = null
}

variable "kms_key_id" {
    description = "KMS key ID to encrypt the volume with."
    type = string
    default = null
}

variable "tags" {
    description = "Tags to apply to volume."
    type = map(string)
    default = {}
}