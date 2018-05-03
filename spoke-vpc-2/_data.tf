provider "aws" {}
provider "template" {}
provider "tls" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu_bionic" {
  most_recent = true
  owners = [ "099720109477" ]
  filter {
    name = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04*-amd64-server-*" ]
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
