variable "region" {
  description = "AWS Region"
  default = "us-east-1"
}

variable "org" {
  description = "Organization name"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default = "172.16.0.0/20"
}

variable "subnet_cidr" {
  description = "Network mask in CIDR format for subnets"
  default = "24"
}
