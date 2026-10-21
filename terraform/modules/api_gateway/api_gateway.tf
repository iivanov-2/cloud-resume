resource "aws_apigatewayv2_api" "lambda-api-gateway" {
  name          = var.aws_api_gateway_name
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["https://${var.aws_cloudfront_distribution_domain_name}"]
    allow_methods = ["GET"]
    max_age       = 86400
  }
}

resource "aws_apigatewayv2_stage" "lambda-api-gateway-stage" {
  api_id      = aws_apigatewayv2_api.lambda-api-gateway.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.lambda-api-gateway-loggroup.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "lambda-api-gateway-integration" {
  api_id             = aws_apigatewayv2_api.lambda-api-gateway.id
  integration_type   = "AWS_PROXY"
  connection_type    = "INTERNET"
  description        = "Lambda API Gateway Integration"
  integration_method = "POST"
  integration_uri    = var.aws_lambda_invoke_arn
}

resource "aws_apigatewayv2_route" "lambda-api-gateway-route" {
  api_id    = aws_apigatewayv2_api.lambda-api-gateway.id
  route_key = "GET /count"
  target    = "integrations/${aws_apigatewayv2_integration.lambda-api-gateway-integration.id}"
}

resource "aws_lambda_permission" "lambda-api-gateway-permissions" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.aws_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda-api-gateway.execution_arn}/*/*"
}

resource "aws_cloudwatch_log_group" "lambda-api-gateway-loggroup" {
  name              = "/aws/api-gw/${aws_apigatewayv2_api.lambda-api-gateway.name}"
  retention_in_days = 30
}
