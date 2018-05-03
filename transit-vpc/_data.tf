provider "aws" {}
provider "template" {}
provider "random" {}
provider "tls" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_ami" "vyos" {
  most_recent = true
  owners = [ "679593333241" ]
  filter {
    name = "name"
    values = [ "VyOS*1.1.8-*" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
}

resource "random_string" "password" {
  length = 12
  special = true
}
