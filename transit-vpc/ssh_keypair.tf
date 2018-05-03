resource "tls_private_key" "vyos" {
  algorithm = "RSA"
  rsa_bits = "2048"
}

resource "aws_key_pair" "vyos" {
  key_name = "${format("vyos-%s", uuid())}"
  public_key = "${tls_private_key.vyos.public_key_openssh}"
  lifecycle {
    ignore_changes = [ "key_name" ]
  }
}

output "private_key" {
  value = "${format("\n\n%s", tls_private_key.vyos.private_key_pem)}"
}

