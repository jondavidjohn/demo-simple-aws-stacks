# Simple AWS Terraform: Static Website Component

This is an HCP Terraform Stacks **component** that deploys a minimal static website using S3 website hosting.

## Files

- `versions.tf`: Terraform + provider requirements
- `variables.tf`: component input variables
- `main.tf`: S3 bucket, website config, public-read policy, sample `index.html`
- `outputs.tf`: website URL and bucket name outputs

## Inputs

| Variable | Type | Description |
|---|---|---|
| `region` | `string` | AWS region to deploy to |
| `tags` | `map(string)` | Tags applied to all resources |
| `project_name` | `string` | Prefix for the S3 bucket name (default: `"site"`) |
| `force_destroy` | `bool` | Allow bucket deletion when non-empty (default: `true`) |

## OIDC / AWS Authentication

AWS credentials are provided by the **stack**, not this component. The stack configures an AWS provider with `assume_role_with_web_identity` using:

- `role_arn` — sourced from a variable set (see the [stack-level README](../README.md))
- `identity_token` — a short-lived OIDC JWT issued per stack run by HCP Terraform

No static AWS credentials or workspace environment variables are needed.
