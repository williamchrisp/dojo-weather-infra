# Save details in SSM for other stacks
resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.tags.Owner}/${var.tags.Project}/vpc-id"
  type  = "String"
  value = aws_vpc.main.id

  tags = var.tags
}