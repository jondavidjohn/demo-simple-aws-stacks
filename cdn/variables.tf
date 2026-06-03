variable "website_endpoint" {
  description = "S3 website endpoint to use as the CloudFront origin."
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket (used for origin ID)."
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}
