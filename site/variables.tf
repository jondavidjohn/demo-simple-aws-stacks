variable "region" {
  description = "AWS region to deploy to (set via tfvars)."
  type        = string
}

variable "project_name" {
  description = "Prefix used to generate the S3 bucket name."
  type        = string
  default     = "site"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.project_name))
    error_message = "project_name must be lowercase alphanumeric and hyphens only (valid S3 bucket prefix)."
  }
}

variable "force_destroy" {
  description = "Whether to allow bucket deletion even when it contains objects."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to created resources."
  type        = map(string)
  default     = {}
}
