resource "aws_s3_bucket" "spoke_vpcs" {
  bucket = "${format("%s-spoke-vpcs", var.ORG)}"
  acl = "private"
      
  tags {
    Name = "${format("%s-spoke-vpcs", var.ORG)}"
    Organization = "${var.ORG}"
  }
}

resource "aws_s3_bucket_object" "vpcs" {
  bucket = "${aws_s3_bucket.spoke_vpcs.id}"
  key = "vpcs/created_by_terraform.txt"
  content = "Created by terraform."
}

resource "aws_s3_bucket_policy" "spoke_vpcs" {
  bucket = "${aws_s3_bucket.spoke_vpcs.id}"
  policy =<<POLICY
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${join("\", \"", formatlist("arn:aws:iam::%s:root", split(",", var.AWS_ACCOUNTS)))}"
        ]
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": "${format("%s/vpcs/*", aws_s3_bucket.spoke_vpcs.arn)}"
    }
  ]
}
POLICY
}
