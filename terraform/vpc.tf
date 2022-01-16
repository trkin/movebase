# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "movebase-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "movebase-vpc"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "movebase-subnet-public-1" {
  vpc_id                  = aws_vpc.movebase-vpc.id
  cidr_block              = "10.0.1.0/24"
  # this will actually differentiate public and private subnets
  map_public_ip_on_launch = "true"
  # aws ec2 describe-availability-zones eu-central-1a
  availability_zone       = "${var.AWS_REGION}a"

  tags = {
    Name = "movebase-subnet-public-1"
  }
}

resource "aws_subnet" "movebase-subnet-public-2" {
  vpc_id                  = aws_vpc.movebase-vpc.id
  cidr_block              = "10.0.2.0/24"
  # this will actually differentiate public and private subnets
  map_public_ip_on_launch = "true"
  # aws ec2 describe-availability-zones eu-central-1a
  availability_zone       = "${var.AWS_REGION}b"

  tags = {
    Name = "movebase-subnet-public-2"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "movebase-igw" {
  vpc_id = aws_vpc.movebase-vpc.id

  tags = {
    Name = "movebase-igw"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "movebase-route-table-public-1" {
  vpc_id = aws_vpc.movebase-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.movebase-igw.id
  }

  tags = {
    Name = "movebase-route-table-public-1"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
# this will actually differentiate public and private subnets
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = aws_subnet.movebase-subnet-public-1.id
  route_table_id = aws_route_table.movebase-route-table-public-1.id
}
resource "aws_route_table_association" "main-public-2-a" {
  subnet_id      = aws_subnet.movebase-subnet-public-2.id
  route_table_id = aws_route_table.movebase-route-table-public-1.id
}
