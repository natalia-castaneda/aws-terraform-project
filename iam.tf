resource "aws_iam_role_policy" "natalia_file_processing_policy" {
  name = "natalia-file-processing-policy"
  role = "natalia-lambda-role-w9h94lyv"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowListBucket"
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = "arn:aws:s3:::natalia-file-system-bucket"
      },
      {
        Sid    = "AllowS3ObjectProcessing"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::natalia-file-system-bucket/*"
      },
      {
        Sid      = "AllowSNSPublish"
        Effect   = "Allow"
        Action   = "sns:Publish"
        Resource = "arn:aws:sns:eu-west-2:656564336285:natalia-file-upload-notification"
      }
    ]
  })
}