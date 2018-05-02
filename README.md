# Transit VPC

[https://www.slideshare.net/AmazonWebServices/networking-many-vpcs-transit-and-shared-architectures-net404-reinvent-2017](https://www.slideshare.net/AmazonWebServices/networking-many-vpcs-transit-and-shared-architectures-net404-reinvent-2017)

This demo builds a simple VPC containing two pfSense firewalls.

# Prerequisites

Some software must be installed prior to building an environment:

- ruby
- bundler (gem install bundler)
- terraform

## Policies

There's a bucket to create with a bucket policy.

```
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn"aws:iam::XXX:root",
          "arn"aws:iam::YYY:root"
        ]
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": "arn:aws:s3:::XXX/pfx/*"
    }
  ]
}
```

