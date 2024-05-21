# Output the ID of the created ElastiCache Redis cluster
output "redis_cluster_id" {
  description = "ID of the created ElastiCache Redis cluster."
  value       = aws_elasticache_cluster.example_redis_cluster.id
}
