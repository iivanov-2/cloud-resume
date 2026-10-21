variable "aws_cloud_resume_bucket_name" {
  #   default     = "cloud-resume-devops-journey"
  description = "Bucket name"
  type        = string

}

variable "aws_account_number" {
  type        = number
  description = "AWS Account ID"
  default     = 204330452644
}

variable "aws_cloudwatch_log_delivery_source_arn" {
  type        = string
  description = "AWS CloudWatch Log Delivery Source ARN"

}

variable "aws_cloudfront_distribution_arn" {
  type        = string
  description = "AWS CloudFront Distribution ARN"

}
