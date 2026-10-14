variable "bucket-name" {
  default     = "cloud-resume-devops-journey"
  description = "Bucket name"
  type        = string

}

variable "s3-origin-name" {
  default = "s3-origin"
  type    = string
}

variable "overwrite-region" {
  type        = string
  description = "Overwrite AWS region for resource"
  default     = "us-east-1"
}

variable "AWS-account-id" {
  type        = number
  description = "AWS Account ID"
  default     = 204330452644
}

variable "function-db-name" {
  type        = string
  description = "AWS Lambda Visitor Count Name"
  default     = "visitor-count"
}
