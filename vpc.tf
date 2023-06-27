# AWS VPC #

resource "aws_vpc" "Prod-VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Prod-VPC"
  }
}

# Public Subnet 1 #

resource "aws_subnet" "Prod-pub-sub1" {
  vpc_id     = aws_vpc.Prod-VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Prod-pub-sub1"
  }
}

# Public Subnet 2 #

resource "aws_subnet" "Prod-pub-sub2" {
  vpc_id     = aws_vpc.Prod-VPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Prod-pub-sub2"
  }
}


# Private Subnet 1 #

resource "aws_subnet" "Prod-priv-sub1" {
  vpc_id     = aws_vpc.Prod-VPC.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Prod-priv-sub1"
  }
}


# Private Subnet 2 #

resource "aws_subnet" "Prod-priv-sub2" {
  vpc_id     = aws_vpc.Prod-VPC.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "Prod-priv-sub2"
  }
}

# Public Route Table #

resource "aws_route_table" "Prod-pub-route-table" {
vpc_id    = aws_vpc.Prod-VPC.id

tags      = {
    Name  = "Prod-pub-route-table"
}
}



# Private Route Table #

resource "aws_route_table" "Prod-priv-route-table" {
vpc_id    = aws_vpc.Prod-VPC.id

tags      = {
    Name  = "Prod-priv-route-table"
}
}


# Route table Association with Subnet #
# Public Route Table Association #


resource "aws_route_table_association" "Public-route-1-association" {
  subnet_id      = aws_subnet.Prod-pub-sub1.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}


resource "aws_route_table_association" "Public-route-2-association" {
  subnet_id      = aws_subnet.Prod-pub-sub2.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}


# Private Route Table Association #


resource "aws_route_table_association" "Private-route-1-association" {
  subnet_id      = aws_subnet.Prod-priv-sub1.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}


resource "aws_route_table_association" "Private-route-2-association" {
  subnet_id      = aws_subnet.Prod-priv-sub2.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}

# Internet Gateway #

resource "aws_internet_gateway" "Prod-IGW" {
  vpc_id = aws_vpc.Prod-VPC.id

  tags = {
    Name = "Prod-IGW"
  }
}

# Associating IGW with Public Route Table #

resource "aws_route" "Prod-igw-association" {
  route_table_id            = aws_route_table.Prod-pub-route-table.id
  gateway_id                = aws_internet_gateway.Prod-IGW.id
  destination_cidr_block    = "0.0.0.0/0"
  
}

# Elastic IP #

resource "aws_eip" "eip" {
   vpc  = true

}

# Nat Gateway #

resource "aws_nat_gateway" "Prod-Nat-Gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.Prod-pub-sub1.id

   tags = {
    Name = "Prod-Nat-Gateway"
  }
}


# Associating NAT Gateway with  Private route table #

resource "aws_route" "Prod-Nat-association"{
route_table_id            = aws_route_table.Prod-priv-route-table.id
gateway_id                = aws_nat_gateway.Prod-Nat-Gateway.id
destination_cidr_block    = "0.0.0.0/0"


}