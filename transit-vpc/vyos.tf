resource "aws_instance" "vyos_1" {
  ami                     = "${data.aws_ami.vyos.id}"
  vpc_security_group_ids  = [ "${aws_security_group.vpn.id}" ]
  subnet_id               = "${aws_subnet.public_subnet_1.id}"
  private_ip              = "100.64.64.10"
  instance_type           = "${var.INSTANCE_TYPE}"
  key_name                = "${aws_key_pair.vyos.key_name}"
  monitoring              = true
  root_block_device {
    volume_type = "gp2"
    volume_size = 8
    delete_on_termination = true
  }
  tags {
    Name = "vyos_1"
    Organization = "${var.ORG}"
  }
}

resource "aws_cloudwatch_metric_alarm" "vyos_1" {
  alarm_name                = "AutoRecoverpfSense1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "StatusCheckFailed_System"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Minimum"
  threshold                 = "1"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = ["arn:aws:automate:${data.aws_region.current.name}:ec2:recover"]
  insufficient_data_actions = []
  dimensions {
    InstanceId = "${aws_instance.vyos_1.id}"
  }
}

resource "aws_eip_association" "vyos_1" {
  instance_id   = "${aws_instance.vyos_1.id}"
  allocation_id = "${aws_eip.vyos_1.id}"
}

output "vyos_password" {
  value = "${random_string.password.result}" 
}
