# Transit VPC

[https://www.slideshare.net/AmazonWebServices/networking-many-vpcs-transit-and-shared-architectures-net404-reinvent-2017](https://www.slideshare.net/AmazonWebServices/networking-many-vpcs-transit-and-shared-architectures-net404-reinvent-2017)

This terraform config builds:

- a simple VPC with a CIDR block of 100.64.0.0/21
- two pfSense firewalls with a random password
- cloudwatch alerts to automatically recover each firewall if the host system fails
- an S3 bucket for use with a [VGW polling Lambda](https://github.com/awslabs/aws-transit-vpc), which I won't understand for a while.
- a KMS key to use in order to encrypt/decrypt documents in the S3 bucket

# Prerequisites

Some software must be installed prior to building an environment:

- ruby
- bundler (gem install bundler)
- terraform

## Resource Tags

If you are a customer configuring your VPC as a spoke to the transit VPC, add the `transitvpcspoke = true` resource tag to your VPC.

## Variables
| Variable | Purpose | Default |
|----------|---------|---------|
| TF_VAR_ORG | Derived from $ORG | |
| TF_VAR_AWS_ACCOUNTS | Contains a list of AWS account IDs that are allowed to add objects to the ${ORG}-spoke-vpcs bucket | |
| TF_VAR_SSH_CIDR_BLOCK | Locks down SSH access to a trusted CIDR block | 0.0.0.0/0 |
| TF_VAR_HTTP_CIDR_BLOCK | Locks down HTTP access to a trusted CIDR block | 0.0.0.0/0 |
| TF_VAR_HTTPS_CIDR_BLOCK | Locks down HTTPS access to a trusted CIDR block | 0.0.0.0/0 |
| TF_VAR_VPN_CIDR_BLOCK | Locks down OPENVPN access to a trusted CIDR block | 0.0.0.0/0 |
| TF_VAR_INSTANCE_TYPE | The instance type of each pfSense box | t2.micro |
