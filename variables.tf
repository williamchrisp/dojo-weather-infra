# VPC Variables
variable "vpc_cidr" {
  type        = string
  description = "Specifies the cidr for the vpc"
  default     = "10.0.0.0/24"
}

variable "subnet_availability_zones" {
  type = list(any)
  description = "Availability Zones in which each subnet will lie. Order specifies subnet."
  default = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
}

variable "public_subnets" {
  type        = list(any)
  description = "Specifies the public subnets in a list. Order specifies AZ"
  default     = ["10.0.0.0/28", "10.0.0.16/28", "10.0.0.32/28"]
}

variable "private_subnets" {
  type        = list(any)
  description = "Specifies the private subnets in a list. Order specifies AZ"
  default     = ["10.0.0.64/26", "10.0.0.128/26", "10.0.0.192/26"]
}

# S3 Variables
variable "bucket" {
  type        = string
  description = "Specifies the name of an S3 Bucket"
  default     = "williamdojoapp"
}

#Tag Variables
variable "tags" {
  type        = map(string)
  description = "Use tags to identify project resources"
  default = {
    Owner   = "williamchrisp"
    Project = "node-weather-app"
  }
}