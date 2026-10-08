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

resource "aws_iam_role_policy_attachment" "lambda-policy1" {
  role       = aws_iam_role.lambda-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy_attachment" "lambda-dynamodb-policy" {
  role       = aws_iam_role.lambda-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess_v2"
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

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda-visitor-count.function_name}"
  retention_in_days = 30
}
