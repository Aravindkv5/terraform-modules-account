
variable "region_code" {
  description = "Region code"
  type        = string
  default     = "NADTC04"
}

variable "account_name" {
  description = "Account name as per naming standard"
  type        = string
  default     = "EXT-SEC"
}

variable "transit_gateway_id" {
  description = "transit gw id"
  type = string
  default = "tgw-0058b410c08c6789e"
}

variable "des" { }