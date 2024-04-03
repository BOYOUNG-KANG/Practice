provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "tf-test-bucket-2" {
  bucket = "tf-test-bucket"

  tags = {
    name = "tf-test-bucket"
    environment = "dev"
  }
}
resource "aws_s3_object" "object-sample-txt" {
  bucket = aws_s3_bucket.tf-test-bucket-2.id
  key    = "sample.txt"
  source = "sample.txt"
}
# IAM 사용자 또는 역할에 대한 액세스 허용하용는 IAM 정책 이용하여 bucket 접근 제어
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.tf-test-bucket-2.id
  policy = data.aws_iam_policy_document.iam-bucket-policy-document.json
}

data "aws_iam_policy_document" "iam-bucket-policy-document" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["123456789012"] # 계정 ID가 "123456789012"인 IAM 사용자에 대한 GetObject 및 ListBucket 작업 허용
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.tf-test-bucket-2.arn,
      "${aws_s3_bucket.tf-test-bucket-2.arn}/*",
    ]
  }
}