
variable "vpc_id" {}
variable "igw_id" {}
variable "transit_gateway_id" {}

variable "associations" {
  type = list(object({
    key     = string  # Stable never-changing key e.g. "A-APP1", "B-TGW1"
    subnet  = string  # Full subnet Name tag — used to look up subnet_ids
    rt_name = string  # Name tag only — changing this will NOT recreate the resource
  }))
}

variable "subnet_ids" {
  type        = map(string)
  description = "Map of subnet names to subnet IDs"
}

variable "tgw_attachment_id" {
  type = string
}

variable "enable_tgw_routes" {        
  description = "Set to false to skip adding TGW routes to route tables"
  type        = bool
  default     = true
}

# Keyed by stable 'key' — rt_name and subnet display name can change freely without recreation
resource "aws_route_table" "rt" {
  for_each = { for a in var.associations : a.key => a }

  vpc_id = var.vpc_id

  tags = {
    Name = each.value.rt_name
  }
}

resource "aws_route_table_association" "assoc" {
  for_each = { for a in var.associations : a.key => a }

  subnet_id      = var.subnet_ids[each.value.subnet]
  route_table_id = aws_route_table.rt[each.key].id
}

locals {
  tgw_routes = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16"
  ]

  tgw_routes_map = var.enable_tgw_routes ? {   # <-- ADD THIS CONDITION
    for combo in setproduct(keys(aws_route_table.rt), local.tgw_routes) :
    "${combo[0]}-${combo[1]}" => {
      route_table_id = aws_route_table.rt[combo[0]].id
      cidr           = combo[1]
    }
  } : {}                                       
}

resource "aws_route" "tgw_routes" {
  for_each = local.tgw_routes_map

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [var.tgw_attachment_id]
}
