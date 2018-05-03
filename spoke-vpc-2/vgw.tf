resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = "${aws_vpc.spoke_2.id}"
  tags {
    "Name" = "${format("%s-%s-to-transit-vgw", var.ORG, data.aws_region.current.name)}"
    "Organization" = "${var.ORG}"
  }
}
