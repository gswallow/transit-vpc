resource "aws_security_group" "vpn" {
  name = "vpn-sg"
  description = "Allow SSH, BGP, HTTP, HTTPS, TCP/1194, UDP/1194"
  vpc_id = "${aws_vpc.transit.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = [ "${var.SSH_CIDR_BLOCK}" ]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = [ "${var.HTTP_CIDR_BLOCK}" ]
  }
  ingress {
    from_port = 179
    to_port = 179
    protocol = "TCP"
    cidr_blocks = [ "10.64.64.0/21" ]
  }
  ingress {
    from_port = 179
    to_port = 179
    protocol = "UDP"
    cidr_blocks = [ "10.64.64.0/21" ]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = [ "${var.HTTPS_CIDR_BLOCK}" ]
  }
  ingress {
    from_port = 1194
    to_port = 1194
    protocol = "TCP"
    cidr_blocks = [ "${var.OPENVPN_CIDR_BLOCK}" ]
  }
  ingress {
    from_port = 1194
    to_port = 1194
    protocol = "UDP"
    cidr_blocks = [ "${var.OPENVPN_CIDR_BLOCK}" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "vpn-sg"
    Environment = "${var.ENV}"
  }
}
