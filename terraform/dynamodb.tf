resource "aws_dynamodb_table" "visit-count" {
  name           = "VisitCount"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "CountNumber"

  attribute {
    name = "CountNumber"
    type = "S"
  }
}
