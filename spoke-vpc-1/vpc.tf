resource "aws_vpc" "spoke_1" {
  cidr_block = "172.16.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags {
    Organization = "${var.ORG}"
    Name = "${format("%s-spoke-vpc-172.16.0.0-16", var.ORG)}"
    spoke_1vpcspoke = "true"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.spoke_1.id}"
  tags {
    Organization = "${var.ORG}"
    Name = "${format("%s-spoke_1-vpc-igw", var.ORG)}"
  }
}

################################################################################
# Public subnets
################################################################################

resource "aws_subnet" "public_subnet_1" {
  vpc_id = "${aws_vpc.spoke_1.id}"
  availability_zone = "${element(sort(data.aws_availability_zones.available.names), 0)}"
  cidr_block = "172.16.0.0/24"
  map_public_ip_on_launch = "true"
  tags {
    Organization = "${var.ORG}"
    Type = "public"
    Name = "${format("public-subnet-%s-172.16.0.0-24", element(sort(data.aws_availability_zones.available.names), 0))}"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = "${aws_vpc.spoke_1.id}"
  availability_zone = "${element(sort(data.aws_availability_zones.available.names), 1)}"
  cidr_block = "172.16.1.0/24"
  map_public_ip_on_launch = "true"
  tags {
    Organization = "${var.ORG}"
    Type = "public"
    Name = "${format("public-subnet-%s-172.16.1.0-24", element(sort(data.aws_availability_zones.available.names), 1))}"
  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = "${aws_vpc.spoke_1.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
  tags {
    Organization = "${var.ORG}"
    Type = "public"
    Name = "public-rtb"
  }
}

resource "aws_route_table_association" "public_subnet_1" {
  subnet_id = "${aws_subnet.public_subnet_1.id}"
  route_table_id = "${aws_route_table.public_rtb.id}"
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id = "${aws_subnet.public_subnet_2.id}"
  route_table_id = "${aws_route_table.public_rtb.id}"
}
