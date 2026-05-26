# Simple AWS Terraform: Static Website

This deploys a minimal static website using S3 website hosting.

## Files

- `versions.tf`: Terraform + providers, AWS provider uses `var.region`
- `variables.tf`: input variables
- `main.tf`: bucket, website config, public-read policy, sample `index.html`
- `outputs.tf`: website URL and bucket outputs
- `terraform.tfvars.example`: sample variable values

## Region via tfvars

Copy and edit:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Set `region` to any AWS region you want.

## HCP Terraform Workload Identity OIDC

In your HCP Terraform workspace, set environment variables:

- `TFC_AWS_PROVIDER_AUTH=true`
- `TFC_AWS_RUN_ROLE_ARN=arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_NAME>`

Then run from HCP Terraform as normal (`plan`/`apply`). No static AWS keys are required.
