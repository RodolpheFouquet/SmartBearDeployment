variable "vpc_cidr" {
}

variable "public_subnets_cidr" {
  type = list(string)
}

variable "private_subnets_cidr" {
  type = list(string)
}

variable "environment" {
}

variable "region" {
}

variable "availability_zones" {
  type = list(string)
}
