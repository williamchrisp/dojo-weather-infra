# Internet Gateway setup and route configuration for the public subnet
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.tags,
        {
            Name = "${var.tags.Owner}-${var.tags.Project}-vpc"
        },
    )
}

# Nat Gateway setup and route configuration for the private network
resource "aws_eip" "natgw" {
    count = length(aws_subnet.private)
    vpc = true

    tags = merge(
        var.tags,
        {
            Name = "${var.tags.Owner}-${var.tags.Project}-ngw-eip-${count.index}",
        },
    )
}

resource "aws_nat_gateway" "gw" {
    count = length(aws_subnet.private)
    allocation_id = aws_eip.natgw[count.index].id
    subnet_id     = aws_subnet.public[count.index].id

    tags = merge(
        var.tags,
        {
            Name = "${var.tags.Owner}-${var.tags.Project}-ngw-${count.index}"
        },
    )
}