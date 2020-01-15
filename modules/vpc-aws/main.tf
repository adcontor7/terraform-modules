locals {
  public_subnets_netnum = var.num_private_subnets + 10
}

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

## Define our VPC
resource "aws_vpc" "default" {
  #FROM BASE
  cidr_block           = var.network_cidr
  enable_dns_hostnames = true

  tags = merge(
    var.network_tags,
    map(
        "Name", "${var.prefix} VPC"
    )
  )
}

# Define the private subnets
resource "aws_subnet" "private-subnet" {
  count = var.num_private_subnets > 0 ? var.num_private_subnets : 0

  vpc_id            = aws_vpc.default.id
  cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.subnets_tags,
    map(
        "Name", "${var.prefix} Private Subnet ${count.index}"
    )
  )
}


resource "aws_subnet" "public-subnet" {
  count = var.num_public_subnets > 0 ? var.num_public_subnets : 0

  vpc_id            = aws_vpc.default.id
  cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, local.public_subnets_netnum)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.subnets_tags,
    map(
        "Name", "${var.prefix} Public Subnet ${count.index}"
    )
  )

}



# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.prefix} VPC IGW"
  }
}

# Define the route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.prefix} Public Subnet RT"
  }
}

# Assign the route table to the public Subnets
resource "aws_route_table_association" "public-rt" {
  count = var.num_public_subnets > 0 ? var.num_public_subnets : 0

  subnet_id = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-rt.id
}



# Define the security group for public subnet
resource "aws_security_group" "sgweb" {
  name = "vpc_web_sg"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.prefix} Public Subnets SG"
  }
}

### Define the security group for private subnet
##resource "aws_security_group" "sgdb"{
##  name = "private_subnets_sg"
##  description = "Allow traffic from public subnet"
##
##  ingress {
##    from_port = 80
##    to_port = 80
##    protocol = "tcp"
##    cidr_blocks = [var.public_subnet_cidr]
##  }
##
##  ingress {
##    from_port = 443
##    to_port = 443
##    protocol = "tcp"
##    cidr_blocks = [var.public_subnet_cidr]
##  }
##
##  #MYSQL EXAMPLE
##  ingress {
##    from_port = 3306
##    to_port = 3306
##    protocol = "tcp"
##    cidr_blocks = [var.public_subnet_cidr]
##  }
##
##  ingress {
##    from_port = -1
##    to_port = -1
##    protocol = "icmp"
##    cidr_blocks = [var.public_subnet_cidr]
##  }
##
##  ingress {
##    from_port = 22
##    to_port = 22
##    protocol = "tcp"
##    cidr_blocks = [var.public_subnet_cidr]
##  }
##
##  vpc_id = aws_vpc.default.id
##
##  tags = {
##    Name = "${var.prefix} Private Subnets SG"
##  }
##}
##
##
##
##
##resource "aws_eip" "nat" {
##  vpc        = true
##  depends_on = [aws_internet_gateway.gw]
##}
##
##resource "aws_nat_gateway" "gw" {
##  count = var.enable_nat_gateway ? 1 : 0
##
##  allocation_id = aws_eip.nat.id
##  subnet_id     = aws_subnet.public-subnet.id
##
##  tags = {
##    Name = "${var.prefix} gw NAT"
##  }
##}


