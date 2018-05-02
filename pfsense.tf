resource "aws_instance" "pfsense_1" {
  ami                     = "${data.aws_ami.netgate.id}"
  vpc_security_group_ids  = [ "${aws_security_group.vpn.id}" ]
  subnet_id               = "${aws_subnet.public_subnet_1.id}"
  private_ip              = "100.64.64.10"
  instance_type           = "${var.INSTANCE_TYPE}"
  key_name                = "${aws_key_pair.pfsense.key_name}"
  monitoring              = true
  user_data               = "${format("password=%s", random_string.password.result)}"
  tags {
    Name = "pfsense_1"
    Organization = "${var.ORG}"
  }
}

resource "aws_instance" "pfsense_2" {
  ami                     = "${data.aws_ami.netgate.id}"
  vpc_security_group_ids  = [ "${aws_security_group.vpn.id}" ]
  subnet_id               = "${aws_subnet.public_subnet_2.id}"
  private_ip              = "100.64.65.10"
  instance_type           = "${var.INSTANCE_TYPE}"
  key_name                = "${aws_key_pair.pfsense.key_name}"
  monitoring              = true
  tags {
    Name = "pfsense_2"
    Organization = "${var.ORG}"
  }
}

resource "aws_eip_association" "pfsense_1" {
  instance_id   = "${aws_instance.pfsense_1.id}"
  allocation_id = "${aws_eip.pfsense_1.id}"
}

resource "aws_eip_association" "pfsense_2" {
  instance_id   = "${aws_instance.pfsense_2.id}"
  allocation_id = "${aws_eip.pfsense_2.id}"
}

output "pfsense_password" {
  value = "${random_string.password.result}" 
}
