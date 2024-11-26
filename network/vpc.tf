provider "aws" {
  region = "sa-east-1"
}

locals {
  cw = terraform.workspace
}

# Criar uma rede simples com  acesso a internet para conexão de uma máquina externa 
## VPC Padrao 
resource "aws_vpc" "vpc_main" {
  cidr_block = var.cidr_block_main_vpc

  tags = {
    Name = "vpc_tf_${local.cw}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_tf_${local.cw}"
  }
}

## INTERNET GATEWAY 
resource "aws_internet_gateway" "igw_main" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "igw_main_${local.cw}"
  }

}

## ROUTE TABLES 

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    Name = "rt_public_${local.cw}"
  }

}

resource "aws_route" "route_public" {
  route_table_id         = aws_route_table.rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_main.id
}

resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route.route_public.id
}