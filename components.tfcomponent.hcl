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

provider "aws" "this" {
  config {
    region = var.region

    assume_role_with_web_identity {
      role_arn           = var.role_arn
      web_identity_token = var.identity_token
    }
  }
}

provider "random" "this" {
  config {
  }
}

provider "time" "this" {
  config {
  }
}

variable "region" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "role_arn" {
  type      = string
  ephemeral = true
}

variable "identity_token" {
  type      = string
  ephemeral = true
}

component "site" {
  source = "./site"

  inputs = {
    region         = var.region
    tags           = var.tags
    role_arn       = var.role_arn
    identity_token = var.identity_token
  }

  providers = {
    aws    = provider.aws.this
    random = provider.random.this
    time   = provider.time.this
  }
}

component "cdn" {
  source = "./cdn"

  inputs = {
    website_endpoint = component.site.website_endpoint
    bucket_name      = component.site.bucket_name
    tags             = var.tags
  }

  providers = {
    aws = provider.aws.this
  }
}

output "website_url" {
  description = "Public HTTP URL of the static site for this deployment."
  value       = component.site.website_url
}

output "cdn_url" {
  description = "HTTPS CloudFront URL for this deployment."
  value       = component.cdn.cdn_url
}
