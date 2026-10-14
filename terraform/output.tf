locals {
  URL = "https://${aws_cloudfront_distribution.s3-distribution.domain_name}"
}

output "Static-Web-Site-URL" {
  value = local.URL
}

output "Lambda-Invoke-URL" {
  value = "${aws_apigatewayv2_stage.lambda-api-gateway-stage.invoke_url}count"
}
