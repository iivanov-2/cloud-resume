resource "aws_s3_bucket" "cloud-resume" {
  bucket        = var.bucket-name
  force_destroy = true

  tags = {
    Name = var.bucket-name
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
            "AWS:SourceArn" = "${aws_cloudfront_distribution.s3-distribution.arn}"
          }
        }
      },
      {
        Sid       = "AWSLogDeliveryWrite"
        Effect    = "Allow"
        Principal = { Service = "delivery.logs.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.cloud-resume.arn}/logs/AWSLogs/${var.AWS-account-id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"      = "bucket-owner-full-control"
            "aws:SourceAccount" = "${var.AWS-account-id}"
          }
          ArnLike = {
            "aws:SourceArn" = "${aws_cloudwatch_log_delivery_source.log-delivery-source.arn}"
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
            "aws:SourceAccount" = "${var.AWS-account-id}"
          }
          ArnLike = {
            "aws:SourceArn" = "${aws_cloudwatch_log_delivery_source.log-delivery-source.arn}"
          }
        }
      }
    ]
  })
}
