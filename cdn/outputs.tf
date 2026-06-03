output "cdn_url" {
  description = "HTTPS URL of the CloudFront distribution."
  value       = "https://${aws_cloudfront_distribution.cdn.domain_name}"
}

output "distribution_id" {
  description = "CloudFront distribution ID."
  value       = aws_cloudfront_distribution.cdn.id
}
