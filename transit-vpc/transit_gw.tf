resource "aws_ec2_transit_gateway" "current" {
  description                     = "Transit gateway for ${var.org}"
  amazon_side_asn                 = "${var.transit_asn}"
  auto_accept_shared_attachments  = "${var.auto_accept_shared_attachments}"
  default_route_table_association = "${var.default_route_table_association}"
  default_route_table_propagation = "${var.default_route_table_propagation}"
  dns_support                     = "${var.dns_support}"
  vpn_ecmp_support                = "${var.vpn_ecmp_support}"

  tags {
    Name         = "${var.org}-${var.region}-transit-gw"
    Organization = "${var.org}"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "current" {
  subnet_ids = ["${aws_subnet.public_subnet_1.id}",
    "${aws_subnet.public_subnet_2.id}",
  ]

  transit_gateway_id = "${aws_ec2_transit_gateway.current.id}"
  vpc_id             = "${aws_vpc.transit.id}"

  tags {
    Name         = "${var.org}-${var.region}-transit-vpc-association"
    Organization = "${var.org}"
  }
}
