resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = "natalia-lambda"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::natalia-file-system-bucket"
}

resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = "natalia-file-system-bucket"

  lambda_function {
    lambda_function_arn = "arn:aws:lambda:eu-west-2:656564336285:function:natalia-lambda"
    events              = ["s3:ObjectCreated:Put"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}