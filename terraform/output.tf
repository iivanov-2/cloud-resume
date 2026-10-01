locals {
  URL = "https://${aws_cloudfront_distribution.s3-distribution.domain_name}"
}

output "URL" {
  value = local.URL
}
