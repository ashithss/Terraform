variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "redis_subnet1" {
  description = "List of subnet IDs for the DB Db subnet group."
  type        = string
  default     = "subnet-05b1e4eb1345120aa"
}

variable "redis_subnet2" {
  description = "List of subnet IDs for the DB Db subnet group."
  type        = string
  default     = "subnet-0d78b00ecc64088e2"
}

variable "cache_node_type" {
  description = "ElastiCache Redis node type."
  type        = string
  default     = "cache.t2.micro"
}

variable "cluster_id" {
  description = "ElastiCache Redis cluster ID."
  type        = string
  default     = "my-redis-cluster"
}