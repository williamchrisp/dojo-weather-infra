# Pulling available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Configuration
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"

    tags = {
        Name = "${var.tags.Owner}-${var.tags.Project}-vpc"
        Owner = "${var.tags.Owner}"
        Project = "${var.tags.Project}"
        }
}

# Subnet configuration
resource "aws_subnet" "public" {
    count = length(var.public_subnets)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnets[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    
    tags = {
        Name = "${var.tags.Owner}-${var.tags.Project}-public-${count.index}"
        Owner = "${var.tags.Owner}"
        Project = "${var.tags.Project}"
        Tier = "Public"
        }
}

resource "aws_subnet" "private" {
    count = length(var.private_subnets)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnets[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "${var.tags.Owner}-${var.tags.Project}-private-${count.index}"
        Owner = "${var.tags.Owner}"
        Project = "${var.tags.Project}"
        Tier = "Private"
        }
}

# Route table creation for each subnet
resource "aws_route_table" "public" {
    count = length(aws_subnet.public)
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    tags = {
        Name = "${var.tags.Owner}-${var.tags.Project}-public-${count.index}"
        Owner = "${var.tags.Owner}"
        Project = "${var.tags.Project}"
    }
}

resource "aws_route_table_association" "public" {
    count = length(aws_subnet.public)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route_table" "private" {
    count = length(aws_subnet.private)
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.gw[count.index].id
    }
    
    tags = {
        Name = "${var.tags.Owner}-${var.tags.Project}-private-${count.index}"
        Owner = "${var.tags.Owner}"
        Project = "${var.tags.Project}"
    }
}

resource "aws_route_table_association" "private" {
    count = length(aws_subnet.private)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private[count.index].id
}
