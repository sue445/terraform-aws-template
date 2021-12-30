variable "aws_account_id" {
  type        = string
  description = "AWS account ID"
}

variable "provider_region" {
  type        = string
  description = "Provider region (see. https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)"
}
