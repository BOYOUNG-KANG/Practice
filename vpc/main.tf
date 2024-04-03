resource "aws_vpc" "tf_test_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    name = "tf_test_vpc"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.tf_test_vpc.id
  cidr_block = var.public_subnet_cidr_block
}
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.tf_test_vpc.id
  cidr_block = var.private_subnet_cidr_block
}
resource "aws_internet_gateway" "tf_test_igw" {
  vpc_id = aws_vpc.tf_test_vpc.id
}

# public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.tf_test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_test_igw.id
  }
}
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.tf_test_vpc.id
}
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# private subnet에서 NAT gateway 이용해 IGW로 나갈 수 있도록 추가 구성
resource "aws_eip" "ft_test_eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "ft_test_nat_gateway" {
  allocation_id = aws_eip.ft_test_eip.id
  subnet_id = aws_subnet.public_subnet.id
}
resource "aws_route" "private_route" {
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ft_test_nat_gateway.id
}