resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name        = "${var.environment}-redis-subnet-group"
  description = "redis subnet group"
  subnet_ids  = var.subnet_ids
}

resource "aws_security_group" "redis_access_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.environment}-redis-access-sg"
  description = "Allow access to redis"

  tags = {
    Name        = "${var.environment}-redis-access-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "redis_sg" {
  name        = "${var.environment}-redis-sg"
  description = "${var.environment} Security Group"
  vpc_id      = var.vpc_id
  tags = {
    Name        = "${var.environment}-redis-sg"
    Environment = var.environment
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.redis_access_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.environment}-redis-cluster"
  engine               = "redis"
  node_type            =  var.instance_class
  num_cache_nodes      = 1
  engine_version       = "3.2.10"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.id
  security_group_ids = [aws_security_group.redis_sg.id]

}