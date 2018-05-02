resource "tls_private_key" "pfsense" {
  algorithm = "RSA"
  rsa_bits = "2048"
}

resource "aws_key_pair" "pfsense" {
  key_name = "${format("pfsense-%s", uuid())}"
  public_key = "${tls_private_key.pfsense.public_key_openssh}"
  lifecycle {
    ignore_changes = [ "key_name" ]
  }
}

output "private_key" {
  value = "${format("\n\n%s", tls_private_key.pfsense.private_key_pem)}"
}

