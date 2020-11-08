output "redis_address" {
  value  = aws_elasticache_cluster.redis.cache_nodes.0.address
}

output "redis_access_sg_id" {
  value = aws_security_group.redis_access_sg.id
}