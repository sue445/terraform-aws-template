# Migrate to S3-native state locking
S3-native state locking introduced at Terraform [v1.10.0](https://github.com/hashicorp/terraform/releases/tag/v1.10.0)

c.f. https://github.com/hashicorp/terraform/pull/35661

This document explains how to migrate if you have been using DynamoDB state locking since before Terraform 1.9.

## 1. Edit [`backend.tf`](backend.tf)
Use [`use_lockfile`](https://developer.hashicorp.com/terraform/language/backend/s3#use_lockfile) instead of [`dynamodb_table`](https://developer.hashicorp.com/terraform/language/backend/s3#dynamodb_table)

```diff
 terraform {
   backend "s3" {
     # NOTE: variables(var and local) are not allowed here
     bucket         = "" # TODO: edit here
     key            = "terraform.tfstate"
     region         = "" # TODO: edit here
-    dynamodb_table = "terraform-lock" # TODO: edit here
+    use_lockfile = true
   }
 }
```

## 2. Update dependencies for Terraform execution
Please do one of the following

### 2-a. Upload the latest [`cloud_formation/setup-terraform.yml`](cloud_formation/setup-terraform.yml) and re-run CloudFormation (Recommendation)

### 2-b. Manually update dependencies
#### [IAM Role] github-oidc-role (Requires)
Before

```json
{
  "Action": [
    "s3:GetObject",
    "s3:PutObject",
    "s3:DeleteObject"
  ],
  "Resource": "arn:aws:s3:::YOUR-BACKEND-BUCKET-NAME/terraform.tfstate",
  "Effect": "Allow"
},
```

After

```json
{
  "Action": [
    "s3:GetObject",
    "s3:PutObject",
    "s3:DeleteObject"
  ],
  "Resource": [
    "arn:aws:s3:::YOUR-BACKEND-BUCKET-NAME/terraform.tfstate",
    "arn:aws:s3:::YOUR-BACKEND-BUCKET-NAME/terraform.tfstate.tflock"
  ],
  "Effect": "Allow"
},
```

#### [IAM Role] github-oidc-role
Remove followings

```json
{
  "Action": [
    "dynamodb:GetItem",
    "dynamodb:PutItem",
    "dynamodb:DeleteItem",
    "dynamodb:DescribeTable",
    "dynamodb:DescribeContinuousBackups",
    "dynamodb:DescribeTimeToLive",
    "dynamodb:ListTagsOfResource"
  ],
  "Resource": "arn:aws:dynamodb:YOUR-REGION:YOUR-AWS-ACCOUNT-ID:table/terraform-lock",
  "Effect": "Allow"
}
```

#### [DynamoDB] terraform-lock
Remove table

## Full changes
See https://github.com/sue445/terraform-aws-template/pull/186
