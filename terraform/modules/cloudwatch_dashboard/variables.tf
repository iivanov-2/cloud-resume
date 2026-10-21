variable "aws_dashboard_name" {
  type        = string
  description = "The name of the dashboard used for monitoring"
  #   default     = "Cloud-Resume-Dashboard"
}

variable "aws_overwrite_default_region" {
  type        = string
  description = "Overwrite AWS region for resource"
  #   default     = "us-east-1"
}

variable "aws_default_region" {
  type        = string
  description = "Default AWS region for resource"
  #   default     = "eu-central-1"
}

variable "aws_databse_name" {
  type        = string
  description = "AWS Lambda Visitor Count Name"
  #   default     = "visitor-count"
}

variable "aws_cloudfront_distribution_id" {
  type        = string
  description = "AWS Cloudfront Distribution ID"
}

variable "aws_api_gateway_id" {
  type        = string
  description = "AWS API Gateway ID"
}

variable "aws_lambda_function_name" {
  type        = string
  description = "AWS Lambda Function Name"
}
