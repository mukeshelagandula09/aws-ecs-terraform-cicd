
locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-alb-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTP traffic from internet"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.alb.id

  description = "Allow outbound traffic"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "ecs" {
  name        = "${local.name_prefix}-ecs-sg"
  description = "Allow application traffic from ALB only"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-ecs-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs.id
  referenced_security_group_id = aws_security_group.alb.id

  description = "Allow application traffic from ALB"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "ecs_egress" {
  security_group_id = aws_security_group.ecs.id

  description = "Allow outbound traffic"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}


resource "aws_security_group" "ecs_instance" {
  name        = "${local.name_prefix}-ecs-instance-sg"
  description = "Security group for ECS EC2 instances"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-ecs-instance-sg"
  })
}

resource "aws_vpc_security_group_egress_rule" "ecs_instance_egress" {
  security_group_id = aws_security_group.ecs_instance.id

  description = "Allow outbound traffic"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
