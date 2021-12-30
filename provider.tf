provider "aws" {
  region              = var.provider_region
  allowed_account_ids = [var.aws_account_id]
}
