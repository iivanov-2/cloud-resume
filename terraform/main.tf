module "s3" {
  source                                 = "./modules/s3"
  aws_cloud_resume_bucket_name           = "cloud-resume-devops-journey"
  aws_cloudfront_distribution_arn        = module.cloudfront.aws_cloudfront_distribution_arn
  aws_cloudwatch_log_delivery_source_arn = module.cloudfront.aws_cloudwatch_log_delivery_arn
}

module "cloudfront" {
  source                             = "./modules/cloudfront"
  aws_cloud_resume_bucket_name       = "cloud-resume-devops-journey"
  aws_overwrite_default_regionn      = "us-east-1"
  aws_cloudfront_origin_name         = "s3-origin"
  aws_s3_bucket_regional_domain_name = module.s3.aws_s3_bucket_regional_domain_name
}

module "lambda" {
  source            = "./modules/lambda"
  aws_function_name = "visitor-count"
  aws_database_name = module.dynamodb.aws_dynamodb_name
}

module "dynamodb" {
  source           = "./modules/dynamodb"
  aws_databse_name = "visitor-count"

}

module "api_gateway" {
  source                                  = "./modules/api_gateway"
  aws_api_gateway_name                    = "lambda-api-gateway"
  aws_cloudfront_distribution_domain_name = module.cloudfront.aws_cloudfront_domain_name
  aws_lambda_invoke_arn                   = module.lambda.aws_lambda_invoke_arn
  aws_lambda_function_name                = module.lambda.aws_lambda_function_name
}

module "dashboard" {
  source                         = "./modules/cloudwatch_dashboard"
  aws_dashboard_name             = "Cloud-Resume-Dashboard"
  aws_databse_name               = "visitor-count"
  aws_default_region             = "eu-central-1"
  aws_overwrite_default_region   = "us-east-1"
  aws_cloudfront_distribution_id = module.cloudfront.aws_cloudfront_id
  aws_api_gateway_id             = module.api_gateway.aws_api_gateway_id
  aws_lambda_function_name       = module.lambda.aws_lambda_function_name
}


