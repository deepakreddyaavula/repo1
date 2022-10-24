#create vpc

resource "aws_vpc" "geo_vpc" {

    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true 

    tags = {
      "Name" = "geo_vpc"
    }
  
}

#create subnet

# creating two public subnets 

resource "aws_subnet" "public_subnet" {
    count = length(var.public_subnet_cidr)
    vpc_id = aws_vpc.geo_vpc.id
    cidr_block = var.public_subnet_cidr[count.index]
    map_public_ip_on_launch = var.map_public_ip_on_launch
    tags ={
        Name = "public_subnet_${count.index}"
    }

}

# creating Internet Gateway

resource "aws_internet_gateway" "geo_gw" {
    vpc_id = aws_vpc.geo_vpc.id

    tags = {
      "Name" = "Geo_internet_gateway"
    }
  
}

# create route table 

resource "aws_route_table" "default" {
    count = length(var.public_subnet_cidr)

vpc_id = aws_vpc.geo_vpc.id
tags = {
    Name = "public_subnet_route_table_${count.index}"
}
  
}

# internet gateway route

resource "aws_route" "internet_gateway_route" {
    count = length(var.public_subnet_cidr)
    destination_cidr_block = "0.0.0.0/0"
    route_table_id = aws_route_table.default[count.index].id
    gateway_id =  aws_internet_gateway.geo_gw.id
  
}

# route table association

resource "aws_route_table_association" "default" {
   count = length(var.public_subnet_cidr)
   subnet_id = aws_subnet.public_subnet[count.index].id
   route_table_id = aws_route_table.default[count.index].id   
}

# create private subnet

resource "aws_subnet" "private_subnet" {
    count = length(var.private_subnet_cidr)
    vpc_id     = aws_vpc.geo_vpc.id
  cidr_block = var.private_subnet_cidr[count.index]
  tags = {
    Name = "private_subnet_${count.index}"
  }
}

# Create nat gateway
resource "aws_nat_gateway" "nat" {
  count = length(var.private_subnet_cidr)

  connectivity_type = "private"

  subnet_id = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "NAT_${count.index}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.geo_gw]
}

# create route table
resource "aws_route_table" "private_route_table" {
  count = length(var.private_subnet_cidr)

  vpc_id = aws_vpc.geo_vpc.id
  tags = {
    Name = "private_subnet_route_table_${count.index}"
  }
}

# internet gateway route
resource "aws_route" "nat_gateway_route" {
  count = length(var.private_subnet_cidr)

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_route_table[count.index].id
  gateway_id             = aws_nat_gateway.nat[count.index].id
}

# route table associateion
resource "aws_route_table_association" "private_route_table_association" {
  count = length(var.private_subnet_cidr)

  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}
