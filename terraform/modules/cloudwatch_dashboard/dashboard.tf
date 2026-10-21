resource "aws_cloudwatch_dashboard" "main-dashboard" {
  dashboard_name = var.aws_dashboard_name
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
              "${var.aws_cloudfront_distribution_id}"
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
          region = var.aws_overwrite_default_region
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
              "${var.aws_api_gateway_id}"
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
          region = var.aws_default_region
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
              "${var.aws_lambda_function_name}",
              "Resource",
              "${var.aws_lambda_function_name}"
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
          region = var.aws_default_region
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
              "${var.aws_databse_name}"
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
          region = var.aws_default_region
          title  = "DynamoDB Metrics"
        }
      }

    ]
  })
}
