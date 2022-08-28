# VPC Variables
variable "vpc_cidr" {
  default = ""
}

variable "public_subnets" {
  default = []
}

variable "private_subnets" {
  default = []
}

variable "tags" {
  default     = {}
}