resource "aws_s3_bucket" "s3" {
  bucket = "natalia-file-system-bucket"
}

resource "aws_s3_bucket_public_access_block" "s3" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "s3" {
  bucket = aws_s3_bucket.s3.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}