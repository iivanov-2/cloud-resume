locals {
  URL = "http://${aws_s3_bucket_website_configuration.static-website.website_endpoint}"
}

output "URL" {
  value = local.URL
}
