data "aws_iam_policy_document" "assume-role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda-role" {
  name               = "lambda-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
}

data "archive_file" "lambda-code-zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/src/lambda_function.py"
  output_path = "${path.module}/../lambda/archive/function.zip"
}

resource "aws_lambda_function" "lambda-visitor-count" {
  filename      = data.archive_file.lambda-code-zip.output_path
  function_name = "visitor-count"
  role          = aws_iam_role.lambda-role.arn
  handler       = "lambda_function.lambda_handler"
  code_sha256   = data.archive_file.lambda-code-zip.output_base64sha256
  runtime       = "python3.14"
}
