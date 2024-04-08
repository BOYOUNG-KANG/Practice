module "vpc_module" {
  source = "../vpc"
}

resource "aws_instance" "tf_test_instance" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = module.vpc_module.public_subnet_id

  tags = {
    Name = "tf_test_instance"
  }

  key_name = aws_key_pair.tf-test-key-pair.id

  user_data = <<-EOF
    #!/bin/bash
    yum install -y nginx
    systemctl start nginx
    systemctl enable nginx
  EOF

  vpc_security_group_ids = [aws_security_group.ssh-access.id, aws_security_group.nginx-access.id]
}

resource "aws_key_pair" "tf-test-key-pair" {
  public_key = var.key_pair
}

resource "aws_security_group" "ssh-access" {
  name = "ssh-access"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "nginx-access" {
  name = "nginx-access"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

