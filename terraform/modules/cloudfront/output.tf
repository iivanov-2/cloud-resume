locals {
  URL = "https://${aws_cloudfront_distribution.s3-distribution.domain_name}"
}

output "aws_cloudwatch_log_delivery_arn" {
  value = aws_cloudwatch_log_delivery_source.log-delivery-source.arn
}

output "aws_cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.s3-distribution.arn
}

output "aws_cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3-distribution.domain_name
}

output "aws_cloudfront_id" {
  value = aws_cloudfront_distribution.s3-distribution.id
}

output "aws_cloudfront_static_url" {
  value = local.URL
}


