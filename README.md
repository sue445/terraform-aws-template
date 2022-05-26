# terraform-aws-template
[Terraform](https://www.terraform.io/) template for [AWS](https://aws.amazon.com/)

## [Workflow](.github/workflows/terraform.yml) features
* Authenticating via [GitHub OIDC provider](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
* Run `terraform apply`
    * Automatically running on `main` branch
    * Manual running on any branch
* Run `terraform plan`, `terraform fmt` and [tflint](https://github.com/terraform-linters/tflint)
* Comment the result of `terraform plan` to PullRequest
* Slack notification

## Requirements
* GitHub Actions
* Terraform v1.0+

## Usage of this template
### 1. Install tools
* [tfenv](https://github.com/tfutils/tfenv)

### 2. Create a repository using this template

### 3. Setup terraform with CloudFormation
1. Download [cloud_formation/setup-terraform.yml](cloud_formation/setup-terraform.yml)
2. Go to [CloudFormation](https://console.aws.amazon.com/console/home)
3. Create stack with downloaded `setup-terraform.yml`

#### Parameters
* `BackendBucketName` **(Required)**
  * Name of backend bucket. 
  * c.f. https://www.terraform.io/language/settings/backends/s3
* `TerraformLockTableName` **(Required)**
  * Name of lock table name for terraform. 
  * c.f. https://www.terraform.io/language/settings/backends/s3
  * default: `terraform-lock`
* `GithubOidcRoleName` **(Required)**
  * IAM Role name for OIDC authentication
  * default: `github-oidc-role`
* `GitHubOrgName` **(Required)**
  * GitHub organization or user name (e.g. `octocat`)
* `GitHubRepositoryName` **(Required)**
  * GitHub repository name (e.g. `Hello-World`)
* `OIDCProviderArn` (optional)
  * Arn for the GitHub OIDC Provider.
  * A new provider will be created if omitted

### 4. Register secrets
* `SLACK_WEBHOOK` (optional)
    * Create from https://slack.com/apps/A0F7XDUAZ

### 5. Edit files
#### [.github/workflows/terraform.yml](.github/workflows/terraform.yml)
Edit followings

* `TERRAFORM_VERSION`
  * Upgrade to the latest version if necessary
* `GITHUB_OIDC_PROVIDER_ROLE`
  * This is crated by [cloud_formation/setup-terraform.yml](cloud_formation/setup-terraform.yml). See CloudFormation stack output
* `AWS_REGION`
  * Same to the region where Cloudformation was executed

#### [.terraform-version](.terraform-version)
* Upgrade to the latest version if necessary
* Same to `TERRAFORM_VERSION` of [.github/workflows/terraform.yml](.github/workflows/terraform.yml)

#### [backend.tf](backend.tf)
Edit followings

* `terraform.backend.bucket`
  * Same to `BackendBucketName` of [cloud_formation/setup-terraform.yml](cloud_formation/setup-terraform.yml) parameter
* `terraform.backend.region`
  * Same to the region where Cloudformation was executed
* `terraform.backend.dynamodb_table`
  * Same to `TerraformLockTableName` of [cloud_formation/setup-terraform.yml](cloud_formation/setup-terraform.yml) parameter

#### [terraform.tfvars](terraform.tfvars)
Edit followings

* `aws_account_id`
  * AWS account ID
* `provider_region`
  * Same to the region where Cloudformation was executed

#### [versions.tf](versions.tf)
Upgrade to the latest version if necessary

* `terraform.required_providers.aws.version`
* `terraform.required_version`

### 6. Run Terraform from local
```bash
tfenv install

terraform init

# Run followings if you upgraded providers
terraform init -upgrade
git add .terraform.lock.hcl
git commit -m "terraform init -upgrade"

git push
```

### 7. Check if GitHub Actions build is executed

## Maintenance for Terraform repository
### Upgrade Terraform core
1. Check latest version
    * https://github.com/hashicorp/terraform/blob/main/CHANGELOG.md
2. Edit `TERRAFORM_VERSION` in [.github/workflows/terraform.yml](.github/workflows/terraform.yml)
3. Edit [.terraform-version](.terraform-version)
4. Run `tfenv install`

### Upgrade Terraform providers (automatically)
1. Edit [.github/dependabot.yml](.github/dependabot.yml)
2. Wait for Dependabot to create a PullRequests

### Upgrade Terraform providers (manually)
1. Check latest versions
    * https://github.com/terraform-providers/terraform-provider-aws/blob/master/CHANGELOG.md
2. Edit `terraform.required_providers.aws.version` in [versions.tf](versions.tf)
3. Run `terraform init -upgrade`

## Other solution
* https://github.com/sue445/terraform-gcp-template
