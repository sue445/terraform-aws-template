terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      # c.f. https://github.com/terraform-providers/terraform-provider-aws/blob/master/CHANGELOG.md
      version = "3.25.0"
    }
  }
  required_version = ">= 0.15" # Edit here
}
