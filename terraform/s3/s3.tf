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
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : [
          "${aws_s3_bucket.cloud-resume.arn}/*"
        ]
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.public-block]
}

# resource "aws_s3_bucket_ownership_controls" "owner-ship-contorls" {
#   bucket = aws_s3_bucket.cloud-resume.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

resource "aws_s3_bucket_public_access_block" "public-block" {
  bucket                  = aws_s3_bucket.cloud-resume.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# resource "aws_s3_bucket_acl" "bucket-acl" {
#   bucket = aws_s3_bucket.cloud-resume.id
#   acl    = "public-read"

#   depends_on = [aws_s3_bucket_public_access_block.public-block]
# }

resource "aws_s3_bucket_website_configuration" "static-website" {
  bucket = aws_s3_bucket.cloud-resume.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}
