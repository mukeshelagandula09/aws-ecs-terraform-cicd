
locals {
  name_prefix = "${var.project_name}-${var.environment}"

  interface_endpoints = {
    ecs = {
      service = "ecs"
    }
    ecs_agent = {
      service = "ecs-agent"
    }
    ecs_telemetry = {
      service = "ecs-telemetry"
    }
    ecr_api = {
      service = "ecr.api"
    }
    ecr_dkr = {
      service = "ecr.dkr"
    }
    cloudwatch_logs = {
      service = "logs"
    }
  }
}

data "aws_region" "current" {}

resource "aws_security_group" "endpoints" {
  name        = "${local.name_prefix}-vpc-endpoints-sg"
  description = "Allow HTTPS from ECS instances to VPC endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTPS from ECS instances"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [var.ecs_instance_security_group_id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name        = "${local.name_prefix}-vpc-endpoints-sg"
    Environment = var.environment
  })
}

resource "aws_vpc_endpoint" "interface" {
  for_each = local.interface_endpoints

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.${each.value.service}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true

  tags = merge(var.common_tags, {
    Name        = "${local.name_prefix}-${each.key}-endpoint"
    Environment = var.environment
  })
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids

  tags = merge(var.common_tags, {
    Name        = "${local.name_prefix}-s3-endpoint"
    Environment = var.environment
  })
}
