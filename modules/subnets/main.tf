
variable "vpc_id" {}
variable "subnets" {
  type = list(object({ name = string, cidr = string, az = string }))
}

# CIDR is the stable for_each key — renaming a subnet only updates the Name tag in-place
resource "aws_subnet" "this" {
  for_each = { for s in var.subnets : s.cidr => s }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.value.name
  }
}

# Return name->id map so callers can look up subnets by Name tag
output "subnet_ids" {
  description = "Map of subnet Name => subnet ID"
  value       = { for k, v in aws_subnet.this : v.tags["Name"] => v.id }
}

output "subnet_ids_by_cidr" {
  description = "Map of subnet CIDR => subnet ID (stable key)"
  value       = { for k, v in aws_subnet.this : k => v.id }
}
