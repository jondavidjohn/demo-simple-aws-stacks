# Stack Config: Simple AWS Static Website

This directory contains an [HCP Terraform Stack](https://developer.hashicorp.com/terraform/language/stacks) that deploys a static website to S3 across multiple AWS regions using workload identity OIDC — no static AWS credentials required.

## Structure

```
components.tfcomponent.hcl   # Component definitions + AWS provider with OIDC
deployments.tfdeploy.hcl     # Deployment instances (one per region) + published outputs
site/                        # Terraform module: S3 static website (component source)
cdn/                         # Terraform module: CloudFront distribution (component source)
```

## Prerequisites

### 1. AWS IAM Role for OIDC

Create an IAM role that trusts the HCP Terraform OIDC provider. The role's trust policy should allow `sts:AssumeRoleWithWebIdentity` from:

- **Provider URL**: `https://app.terraform.io` (or your TFE hostname)
- **Audience**: `aws.workload.identity`

Attach whatever IAM permissions the stack needs (e.g. `AmazonS3FullAccess` for this demo).

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

## Components

Each deployment wires together two components:

- **`site`** — provisions an S3 bucket configured for static website hosting and serves a demo `index.html` over HTTP.
- **`cdn`** — provisions a CloudFront distribution in front of the `site` S3 website endpoint, adding a CDN and HTTPS (via the default CloudFront certificate). It consumes `website_endpoint` and `bucket_name` from the `site` component.

See [`site/README.md`](./site/README.md) for details on the `site` component's inputs and resources.

> **Note:** CloudFront distributions can take 5–15 minutes to fully deploy and propagate to edge locations.

## Published Outputs

`deployments.tfdeploy.hcl` republishes each deployment's CloudFront URL as a stack-level output:

| Output | Description |
|---|---|
| `eu_central_cdn_url` | HTTPS CloudFront URL for the site in `eu-central-1` |
| `us_east_cdn_url` | HTTPS CloudFront URL for the site in `us-east-1` |
| `us_west_cdn_url` | HTTPS CloudFront URL for the site in `us-west-1` |

The value chain flows: `cdn/outputs.tf` → `component.cdn.cdn_url` in `components.tfcomponent.hcl` → stack `output "cdn_url"` → `deployment.<name>.cdn_url` → `publish_output` in `deployments.tfdeploy.hcl`. Each component also exposes a `website_url` output for the direct (HTTP) S3 endpoint if you need it.
