# Create VPC resource
resource "aws_vpc" "jegbu_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "Yes"

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

#NACL for public subnet AZ 1
resource "aws_network_acl" "NACL_1" {
  vpc_id = aws_vpc.jegbu_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "AZ 1 NACL"
  }
}

#NACL for public subnet AZ 2
resource "aws_network_acl" "NACL_2" {
  vpc_id = aws_vpc.jegbu_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "AZ 2 NACL"
  }
}

#NACL for Private Subnet AZ 1
resource "aws_network_acl" "NACL_private_1" {
  vpc_id = aws_vpc.jegbu_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.0.3.0/24"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "Private NACL AZ 1"
  }
}

#NACL for Private Subnet AZ 2
resource "aws_network_acl" "NACL_private_2" {
  vpc_id = aws_vpc.jegbu_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.0.4.0/24"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "Private NACL AZ 2"
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

# Associate Public Subnet 1 to NACL 1
resource "aws_network_acl_association" "NACL_1" {
  network_acl_id = aws_network_acl.NACL_1.id
  subnet_id      = aws_subnet.public_subnet_az_1.id
}

# Associate Public Subnet 2 to NACL 2
resource "aws_network_acl_association" "NACL_2" {
  network_acl_id = aws_network_acl.NACL_2.id
  subnet_id      = aws_subnet.public_subnet_az_2.id
}

# Associate Private Subnet 1 to Private NACL 1
resource "aws_network_acl_association" "Private_NACL_1" {
  network_acl_id = aws_network_acl.NACL_private_1.id
  subnet_id      = aws_subnet.private_subnet_az_1.id
}

# Associate Private Subnet 2 to Private NACL 2
resource "aws_network_acl_association" "Private_NACL_2" {
  network_acl_id = aws_network_acl.NACL_private_2.id
  subnet_id      = aws_subnet.private_subnet_az_2.id
}
