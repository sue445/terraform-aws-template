terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      # c.f. https://github.com/terraform-providers/terraform-provider-aws/blob/main/CHANGELOG.md
      version = "6.9.0"
    }
  }
  required_version = ">= 1.10" # Edit here
}
