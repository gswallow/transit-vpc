resource "aws_kms_key" "spoke_vpcs" {
  description = "KMS key for spoke VPCs"
  policy =<<POLICY
{
  "Version": "2012-10-17",
  "Id": "spoke-vpcs-third-party-access",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${join("\", \"", formatlist("arn:aws:iam::%s:root", split(",", var.AWS_ACCOUNTS)))}"
        ]
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow access for Key Administrators",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_caller_identity.current.account_id}"
      },
      "Action": [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

  tags {
    Name = "spoke-vpcs"
    Organization = "${var.ORG}"
  }
}

resource "aws_kms_alias" "spoke_vpcs" {
  name          = "alias/spoke-vpcs"
  target_key_id = "${aws_kms_key.spoke_vpcs.key_id}"
}
