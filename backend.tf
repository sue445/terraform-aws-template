terraform {
  backend "s3" {
    # NOTE: variables(var and local) are not allowed here
    bucket         = "" # TODO: edit here
    key            = "terraform.tfstate"
    region         = "" # TODO: edit here
    dynamodb_table = "terraform-lock" # TODO: edit here
  }
}
