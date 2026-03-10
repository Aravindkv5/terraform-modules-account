#!/bin/bash
# =============================================================================
# terraform state mv script — Data-ingestion EXT environment
# Run this from: terraform_account/Data-ingestion/EXT/
#
# PURPOSE: Renames state keys from old (full subnet name) format to new
#          stable short-key format so terraform apply only updates tags
#          in-place without destroying/recreating any resources.
#
# USAGE:
#   cd terraform_account/Data-ingestion/EXT
#   chmod +x state_mv_data_ingestion_ext.sh
#   ./state_mv_data_ingestion_ext.sh
# =============================================================================

set -e  # Exit immediately if any state mv command fails

echo "=== Starting terraform state mv for Data-ingestion EXT ==="
echo ""

# -----------------------------------------------------------------------------
# 1. aws_route_table  (9 resources)
# -----------------------------------------------------------------------------
echo "[1/3] Renaming route tables..."

terraform state mv \
  'module.route_tables.aws_route_table.rt["SUB-NADTC04-A-Data-Ingestion-EXT-APP1"]' \
  'module.route_tables.aws_route_table.rt["A-APP1"]'

terraform state mv \
  'module.route_tables.aws_route_table.rt["SUB-NADTC04-A-Data-Ingestion-EXT-MGMT1"]' \
  'module.route_tables.aws_route_table.rt["A-MGMT1"]'

terraform state mv \
  'module.route_tables.aws_route_table.rt["SUB-NADTC04-A-Data-Ingestion-EXT-TGW1"]' \
  'module.route_tables.aws_route_table.rt["A-TGW1"]'

terraform state mv \
  'module.route_tables.aws_route_table.rt["SUB-NADTC04-B-Data-Ingestion-EXT-APP1"]' \
  'module.route_tables.aws_route_table.rt["B-APP1"]'

terraform state mv \
  'module.route_tables.aws_route_table.rt["SUB-NADTC04-B-Data-Ingestion-EXT-MGMT1"]' \
  'module.route_tables.aws_route_table.rt["B-MGMT1"]'

terraform state mv \
  'module.route_tables.aws_route_table.rt["SUB-NADTC04-B-Data-Ingestion-EXT-TGW1"]' \
  'module.route_tables.aws_route_table.rt["B-TGW1"]'

terraform state mv \
  'module.route_tables.aws_route_table.rt["SUB-NADTC04-C-Data-Ingestion-EXT-APP1"]' \
  'module.route_tables.aws_route_table.rt["C-APP1"]'

terraform state mv \
  'module.route_tables.aws_route_table.rt["SUB-NADTC04-C-Data-Ingestion-EXT-MGMT1"]' \
  'module.route_tables.aws_route_table.rt["C-MGMT1"]'

terraform state mv \
  'module.route_tables.aws_route_table.rt["SUB-NADTC04-C-Data-Ingestion-EXT-TGW1"]' \
  'module.route_tables.aws_route_table.rt["C-TGW1"]'

echo "  Done: 9 route tables renamed."
echo ""

# -----------------------------------------------------------------------------
# 2. aws_route_table_association  (9 resources)
# -----------------------------------------------------------------------------
echo "[2/3] Renaming route table associations..."

terraform state mv \
  'module.route_tables.aws_route_table_association.assoc["SUB-NADTC04-A-Data-Ingestion-EXT-APP1"]' \
  'module.route_tables.aws_route_table_association.assoc["A-APP1"]'

terraform state mv \
  'module.route_tables.aws_route_table_association.assoc["SUB-NADTC04-A-Data-Ingestion-EXT-MGMT1"]' \
  'module.route_tables.aws_route_table_association.assoc["A-MGMT1"]'

terraform state mv \
  'module.route_tables.aws_route_table_association.assoc["SUB-NADTC04-A-Data-Ingestion-EXT-TGW1"]' \
  'module.route_tables.aws_route_table_association.assoc["A-TGW1"]'

terraform state mv \
  'module.route_tables.aws_route_table_association.assoc["SUB-NADTC04-B-Data-Ingestion-EXT-APP1"]' \
  'module.route_tables.aws_route_table_association.assoc["B-APP1"]'

terraform state mv \
  'module.route_tables.aws_route_table_association.assoc["SUB-NADTC04-B-Data-Ingestion-EXT-MGMT1"]' \
  'module.route_tables.aws_route_table_association.assoc["B-MGMT1"]'

terraform state mv \
  'module.route_tables.aws_route_table_association.assoc["SUB-NADTC04-B-Data-Ingestion-EXT-TGW1"]' \
  'module.route_tables.aws_route_table_association.assoc["B-TGW1"]'

terraform state mv \
  'module.route_tables.aws_route_table_association.assoc["SUB-NADTC04-C-Data-Ingestion-EXT-APP1"]' \
  'module.route_tables.aws_route_table_association.assoc["C-APP1"]'

terraform state mv \
  'module.route_tables.aws_route_table_association.assoc["SUB-NADTC04-C-Data-Ingestion-EXT-MGMT1"]' \
  'module.route_tables.aws_route_table_association.assoc["C-MGMT1"]'

terraform state mv \
  'module.route_tables.aws_route_table_association.assoc["SUB-NADTC04-C-Data-Ingestion-EXT-TGW1"]' \
  'module.route_tables.aws_route_table_association.assoc["C-TGW1"]'

echo "  Done: 9 route table associations renamed."
echo ""

# -----------------------------------------------------------------------------
# 3. aws_route (tgw_routes)  (27 resources — 9 RTs × 3 CIDRs)
# -----------------------------------------------------------------------------
echo "[3/3] Renaming TGW routes..."

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-A-Data-Ingestion-EXT-APP1-10.0.0.0/8"]' \
  'module.route_tables.aws_route.tgw_routes["A-APP1-10.0.0.0/8"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-A-Data-Ingestion-EXT-APP1-172.16.0.0/12"]' \
  'module.route_tables.aws_route.tgw_routes["A-APP1-172.16.0.0/12"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-A-Data-Ingestion-EXT-APP1-192.168.0.0/16"]' \
  'module.route_tables.aws_route.tgw_routes["A-APP1-192.168.0.0/16"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-A-Data-Ingestion-EXT-MGMT1-10.0.0.0/8"]' \
  'module.route_tables.aws_route.tgw_routes["A-MGMT1-10.0.0.0/8"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-A-Data-Ingestion-EXT-MGMT1-172.16.0.0/12"]' \
  'module.route_tables.aws_route.tgw_routes["A-MGMT1-172.16.0.0/12"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-A-Data-Ingestion-EXT-MGMT1-192.168.0.0/16"]' \
  'module.route_tables.aws_route.tgw_routes["A-MGMT1-192.168.0.0/16"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-A-Data-Ingestion-EXT-TGW1-10.0.0.0/8"]' \
  'module.route_tables.aws_route.tgw_routes["A-TGW1-10.0.0.0/8"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-A-Data-Ingestion-EXT-TGW1-172.16.0.0/12"]' \
  'module.route_tables.aws_route.tgw_routes["A-TGW1-172.16.0.0/12"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-A-Data-Ingestion-EXT-TGW1-192.168.0.0/16"]' \
  'module.route_tables.aws_route.tgw_routes["A-TGW1-192.168.0.0/16"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-B-Data-Ingestion-EXT-APP1-10.0.0.0/8"]' \
  'module.route_tables.aws_route.tgw_routes["B-APP1-10.0.0.0/8"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-B-Data-Ingestion-EXT-APP1-172.16.0.0/12"]' \
  'module.route_tables.aws_route.tgw_routes["B-APP1-172.16.0.0/12"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-B-Data-Ingestion-EXT-APP1-192.168.0.0/16"]' \
  'module.route_tables.aws_route.tgw_routes["B-APP1-192.168.0.0/16"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-B-Data-Ingestion-EXT-MGMT1-10.0.0.0/8"]' \
  'module.route_tables.aws_route.tgw_routes["B-MGMT1-10.0.0.0/8"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-B-Data-Ingestion-EXT-MGMT1-172.16.0.0/12"]' \
  'module.route_tables.aws_route.tgw_routes["B-MGMT1-172.16.0.0/12"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-B-Data-Ingestion-EXT-MGMT1-192.168.0.0/16"]' \
  'module.route_tables.aws_route.tgw_routes["B-MGMT1-192.168.0.0/16"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-B-Data-Ingestion-EXT-TGW1-10.0.0.0/8"]' \
  'module.route_tables.aws_route.tgw_routes["B-TGW1-10.0.0.0/8"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-B-Data-Ingestion-EXT-TGW1-172.16.0.0/12"]' \
  'module.route_tables.aws_route.tgw_routes["B-TGW1-172.16.0.0/12"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-B-Data-Ingestion-EXT-TGW1-192.168.0.0/16"]' \
  'module.route_tables.aws_route.tgw_routes["B-TGW1-192.168.0.0/16"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-C-Data-Ingestion-EXT-APP1-10.0.0.0/8"]' \
  'module.route_tables.aws_route.tgw_routes["C-APP1-10.0.0.0/8"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-C-Data-Ingestion-EXT-APP1-172.16.0.0/12"]' \
  'module.route_tables.aws_route.tgw_routes["C-APP1-172.16.0.0/12"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-C-Data-Ingestion-EXT-APP1-192.168.0.0/16"]' \
  'module.route_tables.aws_route.tgw_routes["C-APP1-192.168.0.0/16"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-C-Data-Ingestion-EXT-MGMT1-10.0.0.0/8"]' \
  'module.route_tables.aws_route.tgw_routes["C-MGMT1-10.0.0.0/8"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-C-Data-Ingestion-EXT-MGMT1-172.16.0.0/12"]' \
  'module.route_tables.aws_route.tgw_routes["C-MGMT1-172.16.0.0/12"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-C-Data-Ingestion-EXT-MGMT1-192.168.0.0/16"]' \
  'module.route_tables.aws_route.tgw_routes["C-MGMT1-192.168.0.0/16"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-C-Data-Ingestion-EXT-TGW1-10.0.0.0/8"]' \
  'module.route_tables.aws_route.tgw_routes["C-TGW1-10.0.0.0/8"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-C-Data-Ingestion-EXT-TGW1-172.16.0.0/12"]' \
  'module.route_tables.aws_route.tgw_routes["C-TGW1-172.16.0.0/12"]'

terraform state mv \
  'module.route_tables.aws_route.tgw_routes["SUB-NADTC04-C-Data-Ingestion-EXT-TGW1-192.168.0.0/16"]' \
  'module.route_tables.aws_route.tgw_routes["C-TGW1-192.168.0.0/16"]'

echo "  Done: 27 TGW routes renamed."
echo ""
echo "=== All 45 state mv operations complete ==="
echo ""
echo "Next step: run 'terraform plan' to confirm zero destroy/recreate actions."
