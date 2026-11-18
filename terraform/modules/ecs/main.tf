
locals {
  name_prefix  = "${var.project_name}-${var.environment}"
  cluster_name = "${local.name_prefix}-cluster"
  service_name = "${local.name_prefix}-service"
  log_group    = "/ecs/${local.name_prefix}/app"
}

# --------------------------------------------------
# ECS-optimized Amazon Linux 2023 AMI
# --------------------------------------------------

data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
}

# --------------------------------------------------
# AWS Region
# --------------------------------------------------

data "aws_region" "current" {}

# --------------------------------------------------
# ECS Cluster
# --------------------------------------------------

resource "aws_ecs_cluster" "main" {
  name = local.cluster_name

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  tags = merge(var.common_tags, {
    Name        = local.cluster_name
    Environment = var.environment
  })
}

# --------------------------------------------------
# CloudWatch Log Group
# --------------------------------------------------

resource "aws_cloudwatch_log_group" "app" {
  name              = local.log_group
  retention_in_days = var.log_retention_days

  tags = merge(var.common_tags, {
    Name        = local.log_group
    Environment = var.environment
  })
}

# --------------------------------------------------
# EC2 Launch Template
# --------------------------------------------------

resource "aws_launch_template" "ecs" {
  name_prefix   = "${local.name_prefix}-ecs-"
  image_id      = data.aws_ssm_parameter.ecs_ami.value
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.ecs_instance_profile_name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.ecs_instance_security_group_id]
  }

  # Enforce IMDSv2
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  # Configure ECS agent
  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "ECS_CLUSTER=${local.cluster_name}" >> /etc/ecs/ecs.config
    echo "ECS_AWSVPC_BLOCK_IMDS=true" >> /etc/ecs/ecs.config
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.common_tags, {
      Name        = "${local.name_prefix}-ecs-instance"
      Environment = var.environment
    })
  }

  tags = var.common_tags
}

# --------------------------------------------------
# EC2 Auto Scaling Group
# --------------------------------------------------

resource "aws_autoscaling_group" "ecs" {
  name                = "${local.name_prefix}-ecs-asg"
  min_size            = 0
  desired_capacity    = 0
  max_size            = 2
  vpc_zone_identifier = var.instance_subnet_ids

  health_check_type = "EC2"

  launch_template {
    id      = aws_launch_template.ecs.id
    version = aws_launch_template.ecs.latest_version
  }

  # Required for ECS capacity provider management
  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = false
  }

  dynamic "tag" {
    for_each = var.common_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    ignore_changes = [
      desired_capacity
    ]
  }
}

# --------------------------------------------------
# ECS Capacity Provider
# --------------------------------------------------

resource "aws_ecs_capacity_provider" "main" {
  name = "portfolio-dev-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs.arn

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 2
      instance_warmup_period    = 300
    }

    managed_termination_protection = "DISABLED"
  }

  tags = var.common_tags
}

# --------------------------------------------------
# Associate Capacity Provider with ECS Cluster
# --------------------------------------------------

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = [
    aws_ecs_capacity_provider.main.name
  ]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    weight            = 1
  }
}

# --------------------------------------------------
# ECS Task Definition
# --------------------------------------------------

resource "aws_ecs_task_definition" "app" {
  family                   = "${local.name_prefix}-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]

  cpu    = "256"
  memory = "512"

  execution_role_arn = var.ecs_task_execution_role_arn
  task_role_arn      = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "portfolio-app"
      image     = "${var.ecr_repository_url}:${var.container_image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app.name
          "awslogs-region"        = data.aws_region.current.region
          "awslogs-stream-prefix" = "app"
        }
      }
    }
  ])

  tags = merge(var.common_tags, {
    Name        = "${local.name_prefix}-task-definition"
    Environment = var.environment
  })
}

# --------------------------------------------------
# ECS Service
# --------------------------------------------------

resource "aws_ecs_service" "app" {
  name            = local.service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_task_count

  # Use ECS EC2 capacity provider
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    weight            = 1
  }

  # ECS task networking
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_task_security_group_id]
    assign_public_ip = false
  }

  # Connect ECS tasks to ALB target group
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "portfolio-app"
    container_port   = 80
  }

  health_check_grace_period_seconds = 60

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  depends_on = [
    aws_ecs_cluster_capacity_providers.main,
    aws_cloudwatch_log_group.app
  ]

  tags = merge(var.common_tags, {
    Name        = local.service_name
    Environment = var.environment
  })
}
