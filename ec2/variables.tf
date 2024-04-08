variable "ami_id" {
  description = "AMI ID"
  default = "ami-09a7535106fbd42d5"
}

variable "instance_type" {
  description = "instance type"
  default = "t3.micro"
}

variable "key_pair" {
  description = "key pair"
  type = string
  default = "/Users/boyoung/.ssh/test_key.pem"
}