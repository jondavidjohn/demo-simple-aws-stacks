terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.11"
    }
  }
}

# In HCP Terraform, AWS credentials come from workload identity OIDC.
# Set workspace env vars such as:
# - TFC_AWS_PROVIDER_AUTH=true
# - TFC_AWS_RUN_ROLE_ARN=arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_NAME>
