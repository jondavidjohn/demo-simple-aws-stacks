output "bucket_name" {
  description = "Name of the S3 bucket hosting the website."
  value       = aws_s3_bucket.website.bucket
}

output "region" {
  description = "AWS region where resources were deployed."
  value       = var.region
}

output "website_endpoint" {
  description = "S3 website endpoint."
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "website_url" {
  description = "HTTP URL for the static website."
  value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}
