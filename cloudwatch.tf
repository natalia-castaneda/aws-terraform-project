resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/natalia-lambda"
  retention_in_days = 7
}