# Internet VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  tags = {
    Name = "main-infra-vpc"
  }
}


# Subnets
resource "aws_subnet" "main-public-1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "main-public-1a"
  }
}

resource "aws_subnet" "main-public-2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "main-public-1b"
  }
}

resource "aws_subnet" "main-private-1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.21.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "main-private-db-1a"
  }
}

resource "aws_subnet" "main-private-2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.22.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "main-private-db-1b"
  }
}

resource "aws_subnet" "main-private-3" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.23.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "main-private-2a"
  }
}

resource "aws_subnet" "main-private-4" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.24.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "main-private-2b"
  }
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# EIP for NAT
resource "aws_eip" "main-eip-1" {
  vpc = true
  tags = {
    Name = "main-EIP-1"
  }
}

resource "aws_eip" "main-eip-2" {
  vpc = true
  tags = {
    Name = "main-EIP-2"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "main-ngw-1" {
  depends_on = [
    aws_eip.main-eip-1
  ]
  allocation_id = aws_eip.main-eip-1.id
  
  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.main-public-1.id
  tags = {
    Name = "main-ngw-1"
  }
}

resource "aws_nat_gateway" "main-ngw-2" {
  depends_on = [
    aws_eip.main-eip-2
  ]
  allocation_id = aws_eip.main-eip-2.id
  
  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.main-public-2.id
  tags = {
    Name = "main-ngw-2"
  }
}

# Creating a Route Table for the Nat Gateway!
resource "aws_route_table" "main-ngw-rt-1" {
  depends_on = [
    aws_nat_gateway.main-ngw-1
  ]
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main-ngw-1.id
  }

  tags = {
    Name = "main-private-1-rt"
  }
}

resource "aws_route_table" "main-ngw-rt-2" {
  depends_on = [
    aws_nat_gateway.main-ngw-2
  ]
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main-ngw-2.id
  }

  tags = {
    Name = "main-private-2-rt"
  }
}

# route tables public
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    Name = "main-public-1-rt"
  }
}

# route associations private
resource "aws_route_table_association" "main-private-1-a" {
  subnet_id      = aws_subnet.main-private-3.id
  route_table_id = aws_route_table.main-ngw-rt-1.id
}

resource "aws_route_table_association" "main-private-1-b" {
  subnet_id      = aws_subnet.main-private-4.id
  route_table_id = aws_route_table.main-ngw-rt-2.id
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = aws_subnet.main-public-1.id
  route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "main-public-1-b" {
  subnet_id      = aws_subnet.main-public-2.id
  route_table_id = aws_route_table.main-public.id
}
