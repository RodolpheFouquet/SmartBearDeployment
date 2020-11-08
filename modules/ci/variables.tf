variable "repository_url" {
}

variable "region" {
}

variable "ecs_cluster_name" {
}

variable "ecs_service_name" {
}

variable "run_task_subnet_id" {
}

variable "run_task_security_group_ids" {
  type        = list(string)
}