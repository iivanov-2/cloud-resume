variable "aws_overwrite_default_regionn" {
  type        = string
  description = "Overwrite AWS region for resource"
  #   default     = "us-east-1"
}

variable "aws_cloudfront_origin_name" {
  #   default = "s3-origin"
  type = string
}

variable "aws_cloud_resume_bucket_name" {
  #   default     = "cloud-resume-devops-journey"
  description = "Bucket name"
  type        = string

}

variable "aws_s3_bucket_regional_domain_name" {
  type        = string
  description = "AWS S3 Regional Domain Name"
}
