resource "aws_vpc" "rent_habesha_vpc" {
  cidr_block = var.rent_habesha_vpc
 // availability_zone = "us-east-1"
 enable_dns_hostnames = true
 enable_dns_support = true
 region = var.region
}
resource "aws_internet_gateway" "rent_habesha_igw" {
  vpc_id = aws_vpc.rent_habesha_vpc.id
  region = var.region
tags = {
  enviroment = var.enviroment
  description = "rent habesha internet gateway"
}
}
resource "aws_subnet" "rent_habesha_public_subnet" {
  for_each = var.rent_habesha_public_subnet
  vpc_id = aws_vpc.rent_habesha_vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = true
  tags = {
    enviroment = var.enviroment
  }
}

resource "aws_subnet" "rent_habesha_private_subnet" {
  for_each = var.rent_habesha_private_subnet
  vpc_id = aws_vpc.rent_habesha_vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    enviroment = var.enviroment
  }
}

resource "aws_eip" "rent_habesha_eip" {
  domain = "vpc"
  tags = {
    enviroment = var.enviroment
  }
}
resource "aws_nat_gateway" "rent_habesha_nat_gw" {
  #for_each = var.rent_habesha_public_subnet
  allocation_id = aws_eip.rent_habesha_eip.id
  #-----use each.key to create NAT per AZ on Production
  subnet_id = aws_subnet.rent_habesha_public_subnet["rent_habesha_public_subnet_az1"].id
  depends_on = [ 
    aws_internet_gateway.rent_habesha_igw
   ]
}
resource "aws_route_table" "rent_habesha_public_rt" {
  vpc_id = aws_vpc.rent_habesha_vpc.id
  route {
    cidr_block = var.public_rt
    gateway_id = aws_internet_gateway.rent_habesha_igw.id
  }
  tags = {
    enviroment = var.enviroment
  }
}
resource "aws_route_table" "rent_habesha_private_rt" {
  vpc_id  = aws_vpc.rent_habesha_vpc.id
  route {
    cidr_block = var.private_rt
    nat_gateway_id = aws_nat_gateway.rent_habesha_nat_gw.id
  }
  tags = {
    enviroment = var.enviroment
  }
}
resource "aws_route_table_association" "rent_habesha_rt_association" {
    for_each = var.rent_habesha_public_subnet
  subnet_id = aws_subnet.rent_habesha_public_subnet[each.key].id
  route_table_id = aws_route_table.rent_habesha_public_rt.id
}
resource "aws_route_table_association" "rent_habesha_private_rt_association" {
    for_each = var.rent_habesha_private_subnet
  subnet_id = aws_subnet.rent_habesha_private_subnet[each.key].id
  route_table_id = aws_route_table.rent_habesha_private_rt.id
}