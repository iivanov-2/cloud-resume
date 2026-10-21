# Required for CloudFront to work and to be secure

# Modern and recommended way by AWS for cache policy and origin policy
# No cookies/query strings in cache key as this is static content that is same for every visitor
data "aws_cloudfront_cache_policy" "cached-policy" {
  name = "Managed-CachingOptimized"
}

# This is the ID card of CloudFront for S3 security policy
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "default-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Actual CloudFron distribution config
resource "aws_cloudfront_distribution" "s3-distribution" {
  enabled = true
  origin {
    domain_name              = var.aws_s3_bucket_regional_domain_name
    origin_id                = var.aws_cloudfront_origin_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.aws_cloudfront_origin_name
    cache_policy_id        = data.aws_cloudfront_cache_policy.cached-policy.id
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  is_ipv6_enabled = true
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

# Optional resources for logging. Not required for CloudFront to work
# Because CloudFront is global service all logging resources must be in us-east-1
resource "aws_cloudwatch_log_delivery_source" "log-delivery-source" {
  region = var.aws_overwrite_default_regionn

  name         = var.aws_cloud_resume_bucket_name
  log_type     = "ACCESS_LOGS"
  resource_arn = aws_cloudfront_distribution.s3-distribution.arn
}

resource "aws_cloudwatch_log_group" "cloud-resume-loggroup" {
  region = var.aws_overwrite_default_regionn
  name   = "cloud-resume-log-group"
}

resource "aws_cloudwatch_log_delivery_destination" "log-destination" {
  region = var.aws_overwrite_default_regionn

  # name          = "s3-destination"
  name          = "cloudfront-access-logs"
  output_format = "json"
  delivery_destination_configuration {
    # destination_resource_arn = "${aws_s3_bucket.cloud-resume.arn}/logs"
    destination_resource_arn = aws_cloudwatch_log_group.cloud-resume-loggroup.arn
  }
}

resource "aws_cloudwatch_log_delivery" "log-delivery" {
  region = var.aws_overwrite_default_regionn

  delivery_source_name     = aws_cloudwatch_log_delivery_source.log-delivery-source.name
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.log-destination.arn

  # s3_delivery_configuration {
  #   suffix_path = "/{DistributionId}/{yyyy}/{MM}/{dd}/{HH}"
  # }
  record_fields = [
    "date",
    "time",
    "c-ip",
    "sc-status",
    "viewer-request-log-data",
    "viewer-response-log-data",
  ]

  # depends_on = [aws_cloudwatch_log_delivery_source.log-delivery-source]
}

resource "aws_ssm_parameter" "cloudfront-id" {
  name        = "/dev/cloud-resume/cloudfront/id"
  description = "Cloud Resume ID of CloudFront"
  type        = "String"
  value       = aws_cloudfront_distribution.s3-distribution.id
}
