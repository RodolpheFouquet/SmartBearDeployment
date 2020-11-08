variable "environment" {
}

variable "vpc_id" {
}

variable "availability_zones" {
  type = list(string)
}

variable "security_groups_ids" {
  type = list(string)
}

variable "subnets_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "database_endpoint" {
}

variable "database_username" {
}

variable "database_password" {
}

variable "database_name" {
}

variable "redis_address" {
  
}

variable "repository_name" {
}

variable "secret_key_base" {
}
