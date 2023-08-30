### SET UP NETWORK

# Create a VPC

resource "aws_vpc" "project_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.dns_support
  enable_dns_hostnames = var.dns_hostnames

  tags = {
    Name = var.vpc_name
  }
}

# create public subnets

resource "aws_subnet" "public_subnets" {
  for_each = var.subnets

  availability_zone = each.value["az"]
  cidr_block        = each.value["cidr_block"]
  vpc_id            = aws_vpc.project_vpc.id
  tags = {
    Name = "${each.key}"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "project_igw" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = var.project_igw
  }
}

# create public route table 
#  To send traffic within the public subnets to the internet gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_igw.id
  }

  tags = {
    Name = var.rt_name
  }

}

## LINK THE PUBLIC ROUTE TABLE WITH THE PUBLIC SUBNETS

# Public route table associations
resource "aws_route_table_association" "subnets_assoc" {
  for_each = var.subnets

  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.public_rt.id
}