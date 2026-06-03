identity_token "aws" {
  audience = ["aws.workload.identity"]
}

store "varset" "workload_identity" {
  name     = "<your-varset-name>"
  category = "terraform"
}

deployment "example_eu_central" {
  inputs = {
    region         = "eu-central-1"
    tags           = { environment = "production" }
    role_arn       = store.varset.workload_identity.aws_role_arn
    identity_token = identity_token.aws.jwt
  }
}

deployment "example_us_east" {
  inputs = {
    region         = "us-east-1"
    tags           = { environment = "production" }
    role_arn       = store.varset.workload_identity.aws_role_arn
    identity_token = identity_token.aws.jwt
  }
}

deployment "example_us_west" {
  inputs = {
    region         = "us-west-1"
    tags           = { environment = "production" }
    role_arn       = store.varset.workload_identity.aws_role_arn
    identity_token = identity_token.aws.jwt
  }
}

publish_output "eu_central_cdn_url" {
  description = "HTTPS CloudFront URL for the static site in eu-central-1."
  value       = deployment.example_eu_central.cdn_url
}

publish_output "us_east_cdn_url" {
  description = "HTTPS CloudFront URL for the static site in us-east-1."
  value       = deployment.example_us_east.cdn_url
}

publish_output "us_west_cdn_url" {
  description = "HTTPS CloudFront URL for the static site in us-west-1."
  value       = deployment.example_us_west.cdn_url
}
