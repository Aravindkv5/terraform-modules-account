
module "vpc" {
  source    = "../../modules/vpc"
  vpc_cidr  = "10.117.254.0/23"
  vpc_name  = "VPC-${var.region_code}-${var.account_name}-${var.des}"
}

module "subnets" {
  source  = "../../modules/subnets"
  vpc_id  = module.vpc.vpc_id
  subnets = [
    { name = "SUB-${var.region_code}-A-${var.account_name}-${var.des}-APP1",  cidr = "10.117.254.0/26",   az = "us-west-2a" },
    { name = "SUB-${var.region_code}-B-${var.account_name}-${var.des}-APP1",  cidr = "10.117.254.64/26",  az = "us-west-2b" },
    { name = "SUB-${var.region_code}-C-${var.account_name}-${var.des}-APP1",  cidr = "10.117.254.128/26", az = "us-west-2c" },
    { name = "SUB-${var.region_code}-A-${var.account_name}-${var.des}-MGMT1", cidr = "10.117.254.192/27", az = "us-west-2a" },
    { name = "SUB-${var.region_code}-B-${var.account_name}-${var.des}-MGMT1", cidr = "10.117.254.224/27", az = "us-west-2b" },
    { name = "SUB-${var.region_code}-C-${var.account_name}-${var.des}-MGMT1", cidr = "10.117.255.0/27",   az = "us-west-2c" },
    { name = "SUB-${var.region_code}-A-${var.account_name}-${var.des}-TGW1",  cidr = "10.117.255.32/28",  az = "us-west-2a" },
    { name = "SUB-${var.region_code}-B-${var.account_name}-${var.des}-TGW1",  cidr = "10.117.255.48/28",  az = "us-west-2b" },
    { name = "SUB-${var.region_code}-C-${var.account_name}-${var.des}-TGW1",  cidr = "10.117.255.64/28",  az = "us-west-2c" },
  ]
  depends_on = [module.vpc]
}


locals {
  tgw_subnet_ids = [
    for name, id in module.subnets.subnet_ids :
    id if can(regex("TGW1", name))
  ]

  mgmt_subnet_ids = [
    for name, id in module.subnets.subnet_ids :
    id if can(regex("MGMT1", name))
  ]
}

module "tgw_attachment" {
  source             = "../../modules/tgw-attachment"
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = local.tgw_subnet_ids
  des                = var.des
  region_code        = var.region_code
  account_name       = var.account_name
}

module "route_tables" {
  source             = "../../modules/route_tables"
  vpc_id             = module.vpc.vpc_id
  igw_id             = ""
  transit_gateway_id = var.transit_gateway_id
  subnet_ids         = module.subnets.subnet_ids
  depends_on         = [module.tgw_attachment]
  tgw_attachment_id  = module.tgw_attachment.tgw_attachment_id

  # 'key' is the stable for_each key — never changes regardless of account_name, region_code, or des.
  # Only 'rt_name' and 'subnet' reference variables; changing them only updates the Name tag in-place.
  associations = [
    { key = "A-APP1",  subnet = "SUB-${var.region_code}-A-${var.account_name}-${var.des}-APP1",  rt_name = "RT-${var.region_code}-A-${var.account_name}-APP1" },
    { key = "B-APP1",  subnet = "SUB-${var.region_code}-B-${var.account_name}-${var.des}-APP1",  rt_name = "RT-${var.region_code}-B-${var.account_name}-APP1" },
    { key = "C-APP1",  subnet = "SUB-${var.region_code}-C-${var.account_name}-${var.des}-APP1",  rt_name = "RT-${var.region_code}-C-${var.account_name}-APP1" },
    { key = "A-MGMT1", subnet = "SUB-${var.region_code}-A-${var.account_name}-${var.des}-MGMT1", rt_name = "RT-${var.region_code}-A-${var.account_name}-MGMT1" },
    { key = "B-MGMT1", subnet = "SUB-${var.region_code}-B-${var.account_name}-${var.des}-MGMT1", rt_name = "RT-${var.region_code}-B-${var.account_name}-MGMT1" },
    { key = "C-MGMT1", subnet = "SUB-${var.region_code}-C-${var.account_name}-${var.des}-MGMT1", rt_name = "RT-${var.region_code}-C-${var.account_name}-MGMT1" },
    { key = "A-TGW1",  subnet = "SUB-${var.region_code}-A-${var.account_name}-${var.des}-TGW1",  rt_name = "RT-${var.region_code}-A-${var.account_name}-TGW1" },
    { key = "B-TGW1",  subnet = "SUB-${var.region_code}-B-${var.account_name}-${var.des}-TGW1",  rt_name = "RT-${var.region_code}-B-${var.account_name}-TGW1" },
    { key = "C-TGW1",  subnet = "SUB-${var.region_code}-C-${var.account_name}-${var.des}-TGW1",  rt_name = "RT-${var.region_code}-C-${var.account_name}-TGW1" },
  ]
}

module "vpc_flow_logs" {
  source       = "../../modules/vpc-flow-log"
  vpc_id       = module.vpc.vpc_id
  region_code  = var.region_code
  account_name = var.account_name
  des          = var.des
}
