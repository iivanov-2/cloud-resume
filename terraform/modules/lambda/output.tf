output "aws_lambda_invoke_arn" {
  value = aws_lambda_function.lambda-visitor-count.invoke_arn
}

output "aws_lambda_function_name" {
  value = aws_lambda_function.lambda-visitor-count.function_name
}
