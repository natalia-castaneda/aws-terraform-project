resource "aws_lambda_function" "natalia_lambda" {
  function_name = "natalia-lambda"
  role          = "arn:aws:iam::656564336285:role/service-role/natalia-lambda-role-w9h94lyv"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.14"

  filename    = "lambda_function.zip"
  memory_size = 128
  timeout     = 3

  environment {
    variables = {
      SNS_TOPIC_ARN = "arn:aws:sns:eu-west-2:656564336285:natalia-file-upload-notification"
    }
  }
}