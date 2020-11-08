variable "environment" {
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
}

variable "allocated_storage" {
  default = "20"
}

variable "instance_class" {
}

variable "multi_az" {
  default = false
}

variable "database_name" {
}

variable "database_username" {
}

variable "database_password" {
}