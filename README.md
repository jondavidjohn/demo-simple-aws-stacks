# Stack Config: Simple AWS Static Website

This directory contains an [HCP Terraform Stack](https://developer.hashicorp.com/terraform/language/stacks) that deploys a static website to S3 across multiple AWS regions using workload identity OIDC — no static AWS credentials required.

## Structure

```
components.tfcomponent.hcl   # Component definition + AWS provider with OIDC
deployments.tfdeploy.hcl     # Deployment instances (one per region)
site/                        # Terraform module (the component source)
```

## Prerequisites

### 1. AWS IAM Role for OIDC

Create an IAM role that trusts the HCP Terraform OIDC provider. The role's trust policy should allow `sts:AssumeRoleWithWebIdentity` from:

- **Provider URL**: `https://app.terraform.io` (or your TFE hostname)
- **Audience**: `aws.workload.identity`

Attach whatever IAM permissions the stack needs (e.g. `AmazonS3FullAccess` for this demo).

(I've found it helpful to have an LLM assist with this once you have `awscli` set up and configured.)

### 2. HCP Terraform Variable Set

Create a **variable set** in HCP Terraform (organization-scoped or project-scoped) with the following Terraform variable:

| Variable | Value |
|---|---|
| `aws_role_arn` | `arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_NAME>` |

Then update `deployments.tfdeploy.hcl` to reference your variable set name:

```hcl
store "varset" "workload_identity" {
  name     = "<your-varset-name>"   # ← set this to your actual varset name
  category = "terraform"
}
```

The `aws_role_arn` value is read from this varset and passed into each deployment as `role_arn`. The OIDC JWT (`identity_token`) is generated automatically per run by HCP Terraform Stacks.

## Deployments

`deployments.tfdeploy.hcl` defines one deployment per target region. Each deployment passes:

- `region` — the AWS region
- `tags` — resource tags (e.g. `environment`)
- `role_arn` — from the variable set
- `identity_token` — auto-generated OIDC JWT

Add or remove `deployment` blocks to control which regions are provisioned.

## Component

See [`site/README.md`](./site/README.md) for details on the component's inputs and resources.
