locals {
  URL = "https://${aws_cloudfront_distribution.s3-distribution.domain_name}"
}

output "URL" {
  value = local.URL
}

output "Cloudfront-ID" {
  value = aws_cloudfront_distribution.s3-distribution.id
}

output "InvokeURL" {
  value = "${aws_apigatewayv2_stage.lambda-api-gateway-stage.invoke_url}count"
}
