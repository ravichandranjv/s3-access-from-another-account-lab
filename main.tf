terraform {
    required_version = ">= 0.12.7"
    required_providers {
        aws = {
        source = "hashicorp/aws"
        }
    }
}

provider "aws" {
    profile = "default"
    region = "${var.region}"
}


resource "aws_s3_bucket" "examplebucket" {
  bucket = "tf-lab-2-bucket"
}

data "aws_caller_identity" "current" {}

resource "aws_iam_user" "user"{
	name = "${data.aws_caller_identity.current.id}"
}
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = "${aws_s3_bucket.examplebucket.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.user.arn}"
      },
      "Action": [ "s3:*" ],
      "Resource": [
        "${aws_s3_bucket.examplebucket.arn}",
        "${aws_s3_bucket.examplebucket.arn}/*"
      ]
    }
  ]
}
EOF
}