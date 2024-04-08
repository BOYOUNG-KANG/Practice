provider "aws" {
  region = "ap-northeast-2"
}

module "iam_module" {
  source = "./iam"
}

module "vpc_module" {
  source = "./vpc"
}

module "s3_module" {
  source = "./s3"
}
module "ec2_module" {
  source = "./ec2"
}