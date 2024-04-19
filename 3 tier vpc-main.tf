# Create VPC resource
resource "aws_vpc" "jegbu_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "jegbu_vpc"
  }
}

# Create internet gateway resource attached to VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.jegbu_vpc.id

  tags = {
    Name = "jegbu_igw"
  }
}

# Create public subnet AZ1
resource "aws_subnet" "public_subnet_az_1" {
  vpc_id     = aws_vpc.jegbu_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet AZ1"
  }
}

# Create public subnet AZ2
resource "aws_subnet" "public_subnet_az_2" {
  vpc_id     = aws_vpc.jegbu_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public Subnet AZ2"
  }
}

# Create private subnet AZ1
resource "aws_subnet" "private_subnet_az_1" {
  vpc_id     = aws_vpc.jegbu_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private Subnet AZ1"
  }
}

# Create private subnet AZ2
resource "aws_subnet" "private_subnet_az_2" {
  vpc_id     = aws_vpc.jegbu_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private Subnet AZ2"
  }
}

# Route Table creation
resource "aws_route_table" "Jegbu" {
  vpc_id = aws_vpc.jegbu_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Jegbu Route Table"
  }
}

# Associate Public Subnet AZ 1 to Route Table
resource "aws_route_table_association" "public_subnet_az_1" {
  subnet_id      = aws_subnet.public_subnet_az_1.id
  route_table_id = aws_route_table.Jegbu.id
}

# Associate Public Subnet AZ 2 to Route Table
resource "aws_route_table_association" "public_subnet_az_2" {
  subnet_id      = aws_subnet.public_subnet_az_2.id
  route_table_id = aws_route_table.Jegbu.id
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "example" {
  vpc_id      = aws_vpc.jegbu_vpc.id
  name        = "jegbu_security_group"
  description = "Example security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jegbu Security Group"
  }
}




