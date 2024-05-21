# Create an Amazon ElastiCache subnet group
resource "aws_elasticache_subnet_group" "example_subnet_group" {
  name       = "example-subnet-group"  # Set the name for the ElastiCache subnet group
  subnet_ids = ["${var.redis_subnet1}","${var.redis_subnet2}"]  # Specify the IDs of the subnets in the subnet group
}

# Create an Amazon ElastiCache parameter group
resource "aws_elasticache_parameter_group" "example_parameter_group" {
  name   = "example-parameter-group"  # Set the name for the ElastiCache parameter group
  family = "redis5.0"  # Set the parameter group family for Redis 5.0

  parameter {
    name  = "maxmemory-policy"  # Set the name of the parameter
    value = "allkeys-lru"  # Set the value for the parameter
  }
}

# Create a single-node Redis cluster
resource "aws_elasticache_cluster" "example_redis_cluster" {
  cluster_id           = var.cluster_id  # Set the ID for the Redis cluster
  engine               = "redis"  # Set the engine for the Redis cluster
  engine_version       = "5.0.6"  # Set the engine version for the Redis cluster
  node_type            = var.cache_node_type  # Set the node type for the Redis cluster
  num_cache_nodes      = 1  # Set the number of cache nodes for the Redis cluster
  subnet_group_name    = aws_elasticache_subnet_group.example_subnet_group.name  # Specify the name of the ElastiCache subnet group
  parameter_group_name = aws_elasticache_parameter_group.example_parameter_group.name  # Specify the name of the ElastiCache parameter group
}

# Create a multi-node Redis cluster (commented out)
# resource "aws_elasticache_replication_group" "multi_node_redis" {
#   replication_group_id          = "multi-node-redis"
#   replication_group_description = "Multi-node Redis replication group"
#   engine_version                = "6.x"
#   node_type                     = var.cache_node_type
#   number_cache_clusters         = 2
#
#   subnet_group_name             = aws_elasticache_subnet_group.example_subnet_group.name
#   parameter_group_name          = aws_elasticache_parameter_group.example_parameter_group.name
#
#   automatic_failover_enabled    = true
#
#   cluster_mode {
#     num_node_groups = 2
#
#     replica_count = 1
#   }
# }
