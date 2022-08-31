# Internet Gateway setup and route configuration for the public subnet
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
    
    tags = {
        Name = "${var.tags.Owner} ${var.tags.Project} IGW"
        Owner = "${var.tags.Owner}"
        Project = "${var.tags.Project}"
    }
}

# Nat Gateway setup and route configuration for the private network
resource "aws_eip" "natgw" {
    count = length(aws_subnet.private)
    vpc = true

    tags = {
        Name = "${var.tags.Owner} ${var.tags.Project} NGW EIP ${count.index}",
        Owner = "${var.tags.Owner}"
        Project = "${var.tags.Project}"
    }
}

resource "aws_nat_gateway" "gw" {
    count = length(aws_subnet.private)
    allocation_id = aws_eip.natgw[count.index].id
    subnet_id     = aws_subnet.public[count.index].id

    tags = {
        Name = "${var.tags.Owner} ${var.tags.Project} NGW ${count.index}"
        Owner = "${var.tags.Owner}"
        Project = "${var.tags.Project}"
    }
}
