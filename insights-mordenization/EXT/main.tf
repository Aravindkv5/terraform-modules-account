
module "vpc" {
  source    = "../../modules/vpc"
  vpc_cidr  = "10.117.248.0/23"
  vpc_name  = "VPC-${var.region_code}-${var.account_name}-${var.des}"
}

module "subnets" {
  source  = "../../modules/subnets"
  vpc_id  = module.vpc.vpc_id
  subnets = [
    { name = "SUB-${var.region_code}-A-${var.account_name}-PUBLIC1", cidr = "10.117.249.0/26", az = "us-west-2a" },
    { name = "SUB-${var.region_code}-A-${var.account_name}-APP1", cidr = "10.117.248.0/25", az = "us-west-2a" },
    { name = "SUB-${var.region_code}-A-${var.account_name}-MGMT1", cidr = "10.117.249.128/27", az = "us-west-2a" },
    { name = "SUB-${var.region_code}-A-${var.account_name}-TGW1", cidr = "10.117.249.192/28", az = "us-west-2a" },
    { name = "SUB-${var.region_code}-B-${var.account_name}-PUBLIC1", cidr = "10.117.249.64/26", az = "us-west-2b" },
    { name = "SUB-${var.region_code}-B-${var.account_name}-APP1", cidr = "10.117.248.128/25", az = "us-west-2b" },
    { name = "SUB-${var.region_code}-B-${var.account_name}-MGMT1", cidr = "10.117.249.160/27", az = "us-west-2b" },
    { name = "SUB-${var.region_code}-B-${var.account_name}-TGW1", cidr = "10.117.249.208/28", az = "us-west-2b" }
  ]
  depends_on = [module.vpc]
}


module "igw" {
  source       = "../../modules/igw"
  vpc_id       = module.vpc.vpc_id
  region_code  = var.region_code
  account_name = var.account_name
}



locals {
  tgw_subnet_ids = [
    for name, id in module.subnets.subnet_ids :
    id if can(regex("TGW1", name))
  ]
}



module "tgw_attachment" {
  source             = "../../modules/tgw-attachment"
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = local.tgw_subnet_ids
  des = var.des
  region_code = var.region_code
  account_name = var.account_name
}


module "route_tables" {
  source            = "../../modules/route_tables"
  vpc_id            = module.vpc.vpc_id
  igw_id            = module.igw.igw_id
  transit_gateway_id = var.transit_gateway_id
  associations      = [
    { subnet = "SUB-${var.region_code}-A-${var.account_name}-APP1", rt_name = "RT-${var.region_code}-A-${var.account_name}-APP1" },
    { subnet = "SUB-${var.region_code}-A-${var.account_name}-PUBLIC1", rt_name = "RT-${var.region_code}-A-${var.account_name}-PUBLIC1" },
    { subnet = "SUB-${var.region_code}-A-${var.account_name}-MGMT1", rt_name = "RT-${var.region_code}-A-${var.account_name}-MGMT1" },
    { subnet = "SUB-${var.region_code}-A-${var.account_name}-TGW1", rt_name = "RT-${var.region_code}-A-${var.account_name}-TGW1" },
    { subnet = "SUB-${var.region_code}-B-${var.account_name}-APP1", rt_name = "RT-${var.region_code}-B-${var.account_name}-APP1" },
    { subnet = "SUB-${var.region_code}-B-${var.account_name}-PUBLIC1", rt_name = "RT-${var.region_code}-B-${var.account_name}-PUBLIC1" },
    { subnet = "SUB-${var.region_code}-B-${var.account_name}-MGMT1", rt_name = "RT-${var.region_code}-B-${var.account_name}-MGMT1" },
    { subnet = "SUB-${var.region_code}-B-${var.account_name}-TGW1", rt_name = "RT-${var.region_code}-B-${var.account_name}-TGW1" }
  ]
  subnet_ids  = module.subnets.subnet_ids
  depends_on = [module.tgw_attachment]
  tgw_attachment_id  = module.tgw_attachment.tgw_attachment_id 
  
  
}

locals {
  mgmt_subnet_ids = [
    for name, id in module.subnets.subnet_ids :
    id if can(regex("MGMT1", name))
  ]
}

module "vpc_flow_logs" {
  source       = "../../modules/vpc-flow-log"
  vpc_id       = module.vpc.vpc_id
  region_code  = var.region_code
  account_name = var.account_name
  des = var.des
}


module "network_firewall" {
  source           = "../../modules/network-firewall"
  vpc_id           = module.vpc.vpc_id
  mgmt_subnet_ids  = local.mgmt_subnet_ids
  firewall_name    = "NF-${var.region_code}-${var.account_name}-External"
}
