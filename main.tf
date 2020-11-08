
locals {
  availability_zones = var.availability_zones
}

provider "aws" {
  region = var.region
}

module "networking" {
  source               = "./modules/networking"
  environment          = var.environment
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.10.0/24", "10.0.20.0/24"]
  region               = var.region
  availability_zones   = local.availability_zones
}

module "database" {
  source            = "./modules/database"
  database_name     = var.database_name
  database_username = var.database_username
  environment       = var.environment
  allocated_storage = var.database_size
  database_password = var.database_password
  subnet_ids        = module.networking.private_subnets_id
  vpc_id            = module.networking.vpc_id
  instance_class    = "db.t2.micro"
}

module "redis" {
  source            = "./modules/redis"
  environment       = var.environment
  subnet_ids        = module.networking.private_subnets_id
  vpc_id            = module.networking.vpc_id
  instance_class    = "cache.t2.micro"
}

module "app" {
  source             = "./modules/app"
  environment        = var.environment
  vpc_id             = module.networking.vpc_id
  availability_zones = local.availability_zones
  repository_name    = "smartbear/prod"
  subnets_ids        = module.networking.private_subnets_id
  public_subnet_ids  = module.networking.public_subnets_id
  security_groups_ids = concat([module.database.db_access_sg_id], module.networking.security_groups_ids)
  database_endpoint = module.database.rds_address
  database_name     = var.database_name
  database_username = var.database_username
  database_password = var.database_password
  redis_address     = module.redis.redis_address
  secret_key_base   = var.secret_key_base
}

module "ci" {
  source                      = "./modules/ci"
  repository_url              = module.app.repository_url
  region                      = var.region
  ecs_service_name            = module.app.service_name
  ecs_cluster_name            = module.app.cluster_name
  run_task_subnet_id          = element(module.networking.private_subnets_id, 0)
  run_task_security_group_ids = concat([module.database.db_access_sg_id, module.app.security_group_id], module.networking.security_groups_ids)
}
