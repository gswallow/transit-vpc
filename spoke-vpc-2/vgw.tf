resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = "${aws_vpc.spoke_2.id}"
  amazon_side_asn = 65120
  tags {
    "Name" = "${format("%s-%s-to-transit-vgw", var.ORG, data.aws_region.current.name)}"
    "Organization" = "${var.ORG}"
  }
}

resource "aws_vpn_gateway_route_propagation" "public" {
  vpn_gateway_id = "${aws_vpn_gateway.vpn_gw.id}"
  route_table_id = "${aws_route_table.public_rtb.id}"
}
