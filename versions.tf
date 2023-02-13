terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      # c.f. https://github.com/terraform-providers/terraform-provider-aws/blob/master/CHANGELOG.md
      version = "4.54.0"
    }
  }
  required_version = ">= 1.0" # Edit here
}
