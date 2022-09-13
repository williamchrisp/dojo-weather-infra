# Grab the current region
data "aws_region" "current" {}

# Create and associate an s3 endpoint to private subnets
resource "aws_vpc_endpoint" "s3" {
    vpc_id       = aws_vpc.main.id
    service_name = "com.amazonaws.${data.aws_region.current.name}.s3"

    tags = merge(
        var.tags,
        {
            Name = "${var.tags.Owner}-${var.tags.Project}-s3-endpoint",
        },
    )
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
    count = length(aws_subnet.private)
    route_table_id = aws_route_table.private[count.index].id
    vpc_endpoint_id = aws_vpc_endpoint.s3.id
}