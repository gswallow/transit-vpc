variable "region" {
  description = "AWS Region"
  default = "us-east-1"
}

variable "org" {
  description = "Organization name"
}

variable "assume_role_arn" {
  description = "IAM role ARN for third party access.  Intentionally left blank."
}

variable "transit_asn" {
  description = "BGP ASN for transit VPC"
  default     = "65534"
}

variable "auto_accept_shared_attachments" {
  description = "Automatically acccept resource attachment requests"
  default     = "enable"
}

variable "default_route_table_association" {
  description = "Automatically associate attached resources to the default route table"
  default     = "enable"
}

variable "default_route_table_propagation" {
  description = "Automatically propagate routes for attached resources"
  default     = "enable"
}

variable "dns_support" {
  description = "Enable DNS support"
  default     = "enable"
}

variable "vpn_ecmp_support" {
  description = "Enable Equal Cost Multi Path routing"
  default     = "enable"
}
