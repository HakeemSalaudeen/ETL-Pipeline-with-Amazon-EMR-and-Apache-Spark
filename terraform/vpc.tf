resource "aws_vpc" "emr-vpc" {
  cidr_block           = "172.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# create a public subnet a
resource "aws_subnet" "emr-publicsubnet-a" {
  vpc_id                  = aws_vpc.emr-vpc.id
  cidr_block              = "172.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
}

# create a public subnet b
resource "aws_subnet" "emr-publicsubnet-b" {
  vpc_id                  = aws_vpc.emr-vpc.id
  cidr_block              = "172.0.1.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true
}

#internet gateway
resource "aws_internet_gateway" "emr-igw" {
  vpc_id = aws_vpc.emr-vpc.id
}

# create a public route table
resource "aws_route_table" "emr-public-RT" {
  vpc_id = aws_vpc.emr-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.emr-igw.id     #route through the IGW
  }
}

resource "aws_route_table_association" "emr-public-RTA" {
  subnet_id      = aws_subnet.emr-publicsubnet-a.id
  route_table_id = aws_route_table.emr-public-RT.id
}

resource "aws_route_table_association" "emr-public-RTA" {
  subnet_id      = aws_subnet.emr-publicsubnet-b.id
  route_table_id = aws_route_table.emr-public-RT.id
}

# security group 
resource "aws_security_group" "emr-sg" {
  name        = "emr-etl-sg"
  description = "Security group for emr"
  vpc_id      = aws_vpc.emr-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "ssh"
    cidr_blocks = ["0.0.0.0/0"]
  }
}