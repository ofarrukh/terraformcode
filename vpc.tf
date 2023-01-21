# Define our VPC
resource "aws_vpc" "default" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true

  tags = {
    Name = "my-terraform-vpc"
  }
}

# Define the public subnet
resource "aws_subnet" "public-subnet" {
  count                   = length(var.availability_zone)
  vpc_id                  = aws_vpc.default.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet" {
  count             = length(var.availability_zone)
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zone, count.index)

  tags = {
    Name = "Private Subnet"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "VPC IGW"
  }
}

# Define the route table
resource "aws_route_table" "web-public-rt" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Subnet RT"
  }
}


# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  count          = length(var.availability_zone)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.web-public-rt.id
}

# Crate NAT Gateways for each private subnet
resource "aws_eip" "terraformtraining-nat" {
  vpc = true
}
resource "aws_nat_gateway" "terraformtraining-nat-gw" {
  allocation_id = aws_eip.terraformtraining-nat.id
  subnet_id     = aws_subnet.public-subnet[0].id
  tags = {
    Name = "NAT-GW"
  }
}

# Create private route table 
resource "aws_route_table" "terraformtraining-private" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terraformtraining-nat-gw.id
  }
  tags = {
    Name = "PrivateSubnetRT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "private-rt" {
  count          = length(var.availability_zone)
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.terraformtraining-private.id
}

# Security groups for Public(jump box) machine

# Define the security group for public subnet
resource "aws_security_group" "sgweb" {
  name        = "jump_box"
  description = "Allow incoming SSH access"

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.default.id

  tags = {
    Name = "Jump Server SG"
  }
}

#### Private SG

# Define the security group for private subnet
resource "aws_security_group" "privateSG" {
  name        = "sg_priavate"
  description = "Allow traffic from public subnet only"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_subnets[0]]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "Private subnet"
  }
}