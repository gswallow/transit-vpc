provider "template" {}

provider "random" {}

provider "tls" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}
