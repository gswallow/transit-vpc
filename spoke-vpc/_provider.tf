provider "aws" {
  region = "${var.region}"
}

provider "template" {}

provider "tls" {}
