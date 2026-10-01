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
        Resource  = "${aws_s3_bucket.cloud-resume.arn}/logs/AWSLogs/204330452644/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"      = "bucket-owner-full-control"
            "aws:SourceAccount" = "204330452644"
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
            "aws:SourceAccount" = "204330452644"
          }
          ArnLike = {
            "aws:SourceArn" = "${aws_cloudwatch_log_delivery_source.log-delivery-source.arn}"
          }
        }
      }
    ]
  })
}

# resource "aws_s3_bucket_policy" "bucket-policy" {
#   bucket = aws_s3_bucket.cloud-resume.id
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Sid" : "PublicReadGetObject",
#         "Effect" : "Allow",
#         "Principal" : "*",
#         "Action" : [
#           "s3:GetObject"
#         ],
#         "Resource" : [
#           "${aws_s3_bucket.cloud-resume.arn}/*"
#         ]
#       }
#     ]
#   })
#   depends_on = [aws_s3_bucket_public_access_block.public-block]
# }

# resource "aws_s3_bucket_public_access_block" "public-block" {
#   bucket                  = aws_s3_bucket.cloud-resume.id
#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_website_configuration" "static-website" {
#   bucket = aws_s3_bucket.cloud-resume.id
#   index_document {
#     suffix = "index.html"
#   }

#   error_document {
#     key = "404.html"
#   }
# }

