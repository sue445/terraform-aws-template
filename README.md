# terraform-aws-template
[Terraform](https://www.terraform.io/) template for AWS

## Features
* Run `terraform apply` (push to main branch or [manually running](https://docs.github.com/en/free-pro-team@latest/actions/managing-workflow-runs/manually-running-a-workflow))
* Run `terraform plan` (except main branch)
* Comment the result of Terraform to PullRequest
* Run [`tflint`](https://github.com/terraform-linters/tflint)
* Slack notification

## Requirements
* GitHub Actions
* Terraform v0.15+

## Usage of this template
### 1. Create a repository using this template
### 2. Create a IAM User for Terraform
https://console.aws.amazon.com/iam/home

The minimum required IAM roles are followings

* `AmazonS3FullAccess`
* `AmazonDynamoDBFullAccess`

Finally, store `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`

### 3. Register secrets
* `AWS_ACCESS_KEY_ID` **(required)**
* `AWS_SECRET_ACCESS_KEY` **(required)**
* `SLACK_WEBHOOK` (optional)
    * Create from https://slack.com/apps/A0F7XDUAZ

### 4. Edit files
#### [.github/workflows/terraform.yml](.github/workflows/terraform.yml)
Edit followings

* `TERRAFORM_VERSION`

#### [.terraform-version](.terraform-version)
* Upgrade to the latest version if necessary
* Same to `TERRAFORM_VERSION` of [.github/workflows/terraform.yml](.github/workflows/terraform.yml)

#### [account.tf](account.tf)
Edit followings

* `aws_account_id`
* `provider_region`
* `backend_bucket_location`
* `backend_bucket_name`
* `terraform_username`

#### [backend.tf](backend.tf)
Edit followings

* `terraform.backend.bucket`
    * Same to `backend_bucket_name` of [account.tf](account.tf)

#### [versions.tf](versions.tf)
Upgrade to the latest version if necessary

* `terraform.required_providers.aws.version`
* `terraform.required_version`

### 5. Create S3 bucket for Terraform backend
https://s3.console.aws.amazon.com/s3/home

* Same to `backend_bucket_name` and `backend_bucket_location` of [account.tf](account.tf)

### 6. Install tools
* [direnv](https://github.com/direnv/direnv)
* [tfenv](https://github.com/tfutils/tfenv)

### 7. Run Terraform from local
```bash
cp .envrc.example .envrc
vi .envrc

direnv allow
tfenv install

terraform init -upgrade
git add .terraform.lock.hcl
git commit -m "terraform init -upgrade"

terraform import aws_s3_bucket.backend __BACKEND_BUCKET_NAME__

terraform plan -lock=false
terraform apply -lock=false

terraform plan
terraform apply

git push
```

### 8. Check if GitHub Actions build is executed

## Maintenance for Terraform repository
### Upgrade Terraform core
1. Check latest version
  * https://github.com/hashicorp/terraform/blob/main/CHANGELOG.md
2. Edit `TERRAFORM_VERSION` in [.github/workflows/terraform.yml](.github/workflows/terraform.yml)
3. Edit [.terraform-version](.terraform-version)
4. Run `tfenv install`

### Upgrade Terraform providers
1. Check latest versions
  * https://github.com/terraform-providers/terraform-provider-aws/blob/master/CHANGELOG.md
2. Edit `terraform.required_providers.aws.version` in [versions.tf](versions.tf)
3. Run `terraform init -upgrade`
