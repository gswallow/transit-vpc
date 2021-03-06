resource "aws_vpc" "transit" {
  cidr_block           = "100.64.64.0/21"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Organization    = "${var.org}"
    Name            = "${format("%s-transit-vpc-100.64.64.0-21", var.org)}"
    transitvpcspoke = "false"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.transit.id}"

  tags {
    Organization = "${var.org}"
    Name         = "${format("%s-transit-vpc-igw", var.org)}"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = "${aws_vpc.transit.id}"
  availability_zone       = "${element(sort(data.aws_availability_zones.available.names), 0)}"
  cidr_block              = "100.64.64.0/24"
  map_public_ip_on_launch = "true"

  tags {
    Organization = "${var.org}"
    Type         = "public"
    Name         = "${format("public-subnet-%s-100.64.64.0-24", element(sort(data.aws_availability_zones.available.names), 0))}"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = "${aws_vpc.transit.id}"
  availability_zone       = "${element(sort(data.aws_availability_zones.available.names), 1)}"
  cidr_block              = "100.64.65.0/24"
  map_public_ip_on_launch = "true"

  tags {
    Organization = "${var.org}"
    Type         = "public"
    Name         = "${format("public-subnet-%s-100.64.65.0-24", element(sort(data.aws_availability_zones.available.names), 1))}"
  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = "${aws_vpc.transit.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Organization = "${var.org}"
    Type         = "public"
    Name         = "public-rtb"
  }
}

resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = "${aws_subnet.public_subnet_1.id}"
  route_table_id = "${aws_route_table.public_rtb.id}"
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = "${aws_subnet.public_subnet_2.id}"
  route_table_id = "${aws_route_table.public_rtb.id}"
}
