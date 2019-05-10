resource "aws_vpc" "current" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Organization = "${var.org}"
    Name         = "${var.org}-spoke-vpc-${var.region}-${replace(var.vpc_cidr, "/", "-")}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.current.id}"

  tags {
    Organization = "${var.org}"
    Name         = "${var.org}-spoke-vpc-igw"
  }
}

################################################################################
# Public subnets
################################################################################

resource "aws_subnet" "public" {
  count                   = "${min(3, length(data.aws_availability_zones.available.names))}"
  vpc_id                  = "${aws_vpc.current.id}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, var.subnet_cidr - element(split("/", var.vpc_cidr), 1), count.index)}"
  map_public_ip_on_launch = "true"

  tags {
    Organization = "${var.org}"
    Type         = "public"
    Name         = "${element(data.aws_availability_zones.available.names, count.index)}-public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.current.id}"

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

resource "aws_route_table_association" "public" {
  count          = "${min(3, length(data.aws_availability_zones.available.names))}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
