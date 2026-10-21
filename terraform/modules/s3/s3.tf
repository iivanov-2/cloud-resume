resource "aws_s3_bucket" "cloud-resume" {
  bucket        = var.aws_cloud_resume_bucket_name
  force_destroy = true

  tags = {
    Name = var.aws_cloud_resume_bucket_name
  }
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.cloud-resume.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.cloud-resume.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "${var.aws_cloudfront_distribution_arn}"
          }
        }
      },
      {
        Sid       = "AWSLogDeliveryWrite"
        Effect    = "Allow"
        Principal = { Service = "delivery.logs.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.cloud-resume.arn}/logs/AWSLogs/${var.aws_account_number}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"      = "bucket-owner-full-control"
            "aws:SourceAccount" = "${var.aws_account_number}"
          }
          ArnLike = {
            "aws:SourceArn" = "${var.aws_cloudwatch_log_delivery_source_arn}"
          }
        }
      },
      {
        Sid       = "AWSLogDeliveryAclCheck"
        Effect    = "Allow"
        Principal = { Service = "delivery.logs.amazonaws.com" }
        Action    = ["s3:GetBucketAcl", "s3:ListBucket"]
        Resource  = aws_s3_bucket.cloud-resume.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = "${var.aws_account_number}"
          }
          ArnLike = {
            "aws:SourceArn" = "${var.aws_cloudwatch_log_delivery_source_arn}"
          }
        }
      }
    ]
  })
}
