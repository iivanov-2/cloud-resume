resource "aws_cloudwatch_dashboard" "main-dashboard" {
  dashboard_name = var.dashboard-name
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 12

        properties = {
          metrics = [
            [
              "AWS/CloudFront",
              "Requests",
              "Region",
              "Global",
              "DistributionId",
              "${aws_cloudfront_distribution.s3-distribution.id}"
            ],
            [
              ".",
              "TotalErrorRate",
              ".",
              ".",
              ".",
              "."
            ],
            [
              ".",
              "4xxErrorRate",
              ".",
              ".",
              ".",
              "."
            ],
            [
              ".",
              "5xxErrorRate",
              ".",
              ".",
              ".",
              "."
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.overwrite-region
          title  = "CloudFront metrics"
        }
      },
      {
        type   = "metric",
        x      = 12
        y      = 0
        width  = 12
        height = 12

        properties = {
          metrics = [
            [
              "AWS/ApiGateway",
              "Latency",
              "Stage",
              "$default",
              "ApiId",
              "${aws_apigatewayv2_api.lambda-api-gateway.id}"
            ],
            [
              ".",
              "5xx",
              ".",
              ".",
              ".",
              "."
            ],
            [
              ".",
              "4xx",
              ".",
              ".",
              ".",
              "."
            ],
            [
              ".",
              "Count",
              ".",
              ".",
              ".",
              "."
            ]
          ]
          region = var.default-region
          title  = "API Gateway Metrics"
        }
      },
      {
        type   = "metric",
        x      = 0
        y      = 12
        width  = 12
        height = 12

        properties = {
          metrics = [
            [
              "AWS/Lambda",
              "Throttles",
              "FunctionName",
              "${aws_lambda_function.lambda-visitor-count.function_name}",
              "Resource",
              "${aws_lambda_function.lambda-visitor-count.function_name}"
            ],
            [
              ".",
              "Duration",
              ".",
              ".",
              ".",
              "."
            ],
            [
              ".",
              "Invocations",
              ".",
              ".",
              ".",
              "."
            ],
            [
              ".",
              "Errors",
              ".",
              ".",
              ".",
              "."
            ]
          ]
          region = var.default-region
          title  = "Lambda Metrics"
        }
      },
      {
        type   = "metric",
        x      = 12
        y      = 12
        width  = 12
        height = 12

        properties = {
          metrics = [
            [
              "AWS/DynamoDB",
              "ConsumedWriteCapacityUnits",
              "TableName",
              "${var.function-db-name}"
            ],
            [
              ".",
              "ConsumedReadCapacityUnits",
              ".",
              "."
            ],
            [
              ".",
              "ProvisionedReadCapacityUnits",
              ".",
              "."
            ],
            [
              ".",
              "ProvisionedWriteCapacityUnits",
              ".",
              "."
            ]
          ]
          region = var.default-region
          title  = "DynamoDB Metrics"
        }
      }

    ]
  })
}
