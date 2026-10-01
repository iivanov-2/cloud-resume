# Required for CloudFront to work and to be secure

# Modern and recommended way by AWS for cache policy and origin policy
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
    domain_name              = aws_s3_bucket.cloud-resume.bucket_regional_domain_name
    origin_id                = var.s3-origin-name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.s3-origin-name
    cache_policy_id        = data.aws_cloudfront_cache_policy.cached-policy.id
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  is_ipv6_enabled = false
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

# Optional resources for logging. Not required for CloudFront to work
resource "aws_cloudwatch_log_delivery_source" "log-delivery-source" {
  region = "us-east-1"

  name         = var.bucket-name
  log_type     = "ACCESS_LOGS"
  resource_arn = aws_cloudfront_distribution.s3-distribution.arn
}

resource "aws_cloudwatch_log_delivery_destination" "log-destination" {
  region = "us-east-1"

  name          = "s3-destination"
  output_format = "json"
  delivery_destination_configuration {
    destination_resource_arn = "${aws_s3_bucket.cloud-resume.arn}/logs"
  }
}

resource "aws_cloudwatch_log_delivery" "log-delivery" {
  region = "us-east-1"

  delivery_source_name     = aws_cloudwatch_log_delivery_source.log-delivery-source.name
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.log-destination.arn

  s3_delivery_configuration {
    suffix_path = "/204330452644/{DistributionId}/{yyyy}/{MM}/{dd}/{HH}"
  }
}
