output "aws_api_gateway_id" {
  value = aws_apigatewayv2_api.lambda-api-gateway.id
}

output "aws_lambda_invoke_url" {
  value = "${aws_apigatewayv2_stage.lambda-api-gateway-stage.invoke_url}count"
}
