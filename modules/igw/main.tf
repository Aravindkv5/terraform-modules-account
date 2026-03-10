
variable "vpc_id" {}
variable "region_code" {}
variable "account_name" {}

resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id
  tags = {
    Name = "IGW-${var.region_code}-${var.account_name}"
  }
}

output "igw_id" {
  value = aws_internet_gateway.this.id
}
