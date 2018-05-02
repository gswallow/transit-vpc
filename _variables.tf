# Variables imported as TF_VAR_*
variable "ENV" {}

# SSH bastion related variable
variable "SSH_CIDR_BLOCK" { default = "0.0.0.0/0" }
variable "HTTP_CIDR_BLOCK" { default = "0.0.0.0/0" }
variable "HTTPS_CIDR_BLOCK" { default = "0.0.0.0/0" }
variable "OPENVPN_CIDR_BLOCK" { default = "0.0.0.0/0" }
variable "INSTANCE_TYPE" { default = "t2.micro" }