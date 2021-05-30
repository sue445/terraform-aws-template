terraform {
  backend "s3" {
    # NOTE: variables(var and local) are not allowed here
    bucket         = "YOUR-BUCKET-NAME-terraform"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-lock"
  }
}

resource "aws_s3_bucket" "backend" {
  bucket = "YOUR-BUCKET-NAME-terraform"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "backend" {
  bucket = aws_s3_bucket.backend.id

  policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${local.aws_account_id}:user/${local.terraform_username}"
      },
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.backend.id}"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${local.aws_account_id}:user/${local.terraform_username}"
      },
      "Action": [
          "s3:GetObject",
          "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.backend.id}/*"
      ]
    }
  ]
}
JSON
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name           = "terraform-lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
