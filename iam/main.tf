provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_user" "tf_test_admin" {
  name = "tf_test_admin"
  path = "/system/"
}
resource "aws_iam_user" "tf_test_viewer" {
  name = "tf_test_viewer"
  path = "/system/"
}

resource "aws_iam_group" "developer_group" {
  name = "developer_group"
  path = "/system/"
}

resource "aws_iam_group_membership" "developer_membership" {
  name  = "developer_membership"

  users = [
    aws_iam_user.tf_test_admin.name,
    aws_iam_user.tf_test_viewer.name
  ]

  group = "developer_group"
}

resource "aws_iam_policy_attachment" "admin_policy_attachment" {
  name       = "admin_policy_attachment"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  users = [
    aws_iam_user.tf_test_admin.name
  ]
}
resource "aws_iam_policy_attachment" "viewer_policy_attachment" {
  name       = "viewer_policy_attachment"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  users = [
    aws_iam_user.tf_test_viewer.name
  ]
}