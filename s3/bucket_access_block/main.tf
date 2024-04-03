provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "tf-test-bucket-1" {
  bucket = "tf-test-bucket-2"

  tags = {
    name = "tf-test-bucket-2"
    environment = "dev"
  }
}
resource "aws_s3_object" "object-sample-txt" {
  bucket = aws_s3_bucket.tf-test-bucket-1.id
  key    = "sample.txt"
  source = "sample.txt"
}
# s3 bucket policy 이용하여 bucket 접근 제어(퍼블릭 엑세스 차단하거나 허용)
resource "aws_s3_bucket_public_access_block" "public-access" {
  bucket = aws_s3_bucket.tf-test-bucket-1.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.tf-test-bucket-1.id
  depends_on = [
    aws_s3_bucket_public_access_block.public-access
  ]
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"PublicRead",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${aws_s3_bucket.tf-test-bucket-1.id}/*"]
    }
  ]
}
POLICY
}