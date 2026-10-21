output "aws_cloudfront_static_url" {
  value = module.cloudfront.aws_cloudfront_static_url
}

output "aws_lambda_invoke_url" {
  value = module.api_gateway.aws_lambda_invoke_url
}
