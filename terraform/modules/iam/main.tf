
locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# EC2 instance trust policy
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# ECS task trust policy
data "aws_iam_policy_document" "ecs_tasks_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS EC2 instance role
resource "aws_iam_role" "ecs_instance" {
  name               = "${local.name_prefix}-ecs-instance-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-ecs-instance-role"
  })
}

# Attach ECS EC2 managed policy
resource "aws_iam_role_policy_attachment" "ecs_instance" {
  role = aws_iam_role.ecs_instance.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# EC2 instance profile
resource "aws_iam_instance_profile" "ecs" {
  name = "${local.name_prefix}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance.name

  tags = var.common_tags
}

# ECS task execution role
resource "aws_iam_role" "ecs_task_execution" {
  name               = "${local.name_prefix}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-ecs-task-execution-role"
  })
}

# Attach ECS task execution policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role = aws_iam_role.ecs_task_execution.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS application task role
resource "aws_iam_role" "ecs_task" {
  name               = "${local.name_prefix}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-ecs-task-role"
  })
}
