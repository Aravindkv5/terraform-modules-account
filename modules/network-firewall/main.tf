
variable "vpc_id" {}
variable "mgmt_subnet_ids" {
  type = list(string)
}
variable "firewall_name" {
  default = "NetworkFirewall"
}

# 1. Rule Group to allow outbound HTTPS
resource "aws_networkfirewall_rule_group" "allow_https" {
  name     = "${var.firewall_name}-allow-https"
  capacity = 100
  type     = "STATEFUL"

  rule_group {
    rules_source {
      rules_string = <<EOT
pass tcp any any -> any 443 (sid:1;)
EOT
    }
  }
}

# 2. Firewall Policy
resource "aws_networkfirewall_firewall_policy" "this" {
  name = "${var.firewall_name}-policy"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateful_rule_group_reference {
        resource_arn = aws_networkfirewall_rule_group.allow_https.arn
      }
  }
}

# 3. Firewall
resource "aws_networkfirewall_firewall" "this" {
  name               = var.firewall_name
  firewall_policy_arn = aws_networkfirewall_firewall_policy.this.arn
  vpc_id             = var.vpc_id

  dynamic "subnet_mapping" {
    for_each = var.mgmt_subnet_ids
    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = {
    Name = var.firewall_name
  }
}

output "firewall_id" {
  value = aws_networkfirewall_firewall.this.id
}
