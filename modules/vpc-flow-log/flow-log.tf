
variable "vpc_id" {}
variable "region_code" {}
variable "account_name" {}

variable "des" {
  description = "Allowed values: EXT or INT"
  type        = string

  validation {
    condition     = contains(["EXT", "INT"], var.des)
    error_message = "Invalid value for des. Allowed values are 'EXT' or 'INT'."
  }
}

resource "aws_cloudwatch_log_group" "flow_logs_group" {
  name              = "${lower(var.region_code)}-${lower(var.account_name)}-${var.des}-vpc-flow-logs"
  retention_in_days = 90
}

# name_prefix instead of name — IAM role 'name' is immutable in AWS.
# Changing account_name would force destroy+recreate if 'name' were used.
resource "aws_iam_role" "flow_logs_role" {
  name_prefix = "vpc-flow-logs-${var.region_code}-${var.des}-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "flow_logs_inline_policy" {
  name = "flow-logs-inline-policy"
  role = aws_iam_role.flow_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_flow_log" "vpc_flow_logs" {
  log_destination      = aws_cloudwatch_log_group.flow_logs_group.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id
  iam_role_arn         = aws_iam_role.flow_logs_role.arn

  tags = {
    Name = "${var.region_code}-${var.account_name}-${var.des}-vpc-flow-logs"
  }
}

output "flow_log_group_name" {
  value = aws_cloudwatch_log_group.flow_logs_group.name
}
