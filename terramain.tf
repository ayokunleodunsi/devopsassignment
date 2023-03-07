terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.57.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "typemanvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc_1"
  }
}

resource "aws_subnet" "hqsubnet" {
  vpc_id     = aws_vpc.typemanvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet_1"
  }
}

resource "aws_internet_gateway" "hqigw" {
  vpc_id = aws_vpc.typemanvpc.id

  tags = {
    Name = "igw_1"
  }
}

resource "aws_route_table" "hqroute" {
  vpc_id = aws_vpc.typemanvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hqigw.id
  }

   tags = {
    Name = "route_1"
  }
}

resource "aws_route_table_association" "hqroute_assoc" {
  subnet_id      = aws_subnet.hqsubnet.id
  route_table_id = aws_route_table.hqroute.id
}

resource "aws_security_group" "hqsg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.typemanvpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  tags = {
    Name = "sg_1"
  }
}