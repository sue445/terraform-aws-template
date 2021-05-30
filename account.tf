locals {
  aws_account_id = "000000000000" # TODO: edit here

  # c.f. https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
  provider_region = "ap-northeast-1" # TODO: edit here

  # c.f. https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
  backend_bucket_location = "ap-northeast-1" # TODO: edit here

  backend_bucket_name = "YOUR-BUCKET-NAME-terraform"

  # IAM username for Terraform
  terraform_username = "terraform"
}

provider "aws" {
  region              = "ap-northeast-1"
  allowed_account_ids = [local.aws_account_id]
}
