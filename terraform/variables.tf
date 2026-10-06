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
