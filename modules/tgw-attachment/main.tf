
variable "transit_gateway_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}
variable "region_code" {
  description = "Region code"
  type        = string

}

variable "account_name" {
  description = "Account name as per naming standard"
  type        = string
  
}


variable "des" {
  description = "Allowed values: EXT or INT"
  type        = string

  validation {
    condition     = contains(["EXT", "INT"], var.des)
    error_message = "Invalid value for des. Allowed values are 'EXT' or 'INT'."
  }
}


resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids

  tags = {
    Name = "TGW-${var.region_code}-${var.account_name}-${var.des}-Attachment"
  }
}

output "tgw_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.this.id
}
