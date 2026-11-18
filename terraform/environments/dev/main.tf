
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.15.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "personal"

  default_tags {
    tags = var.common_tags
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr

  availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    2
  )

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  enable_nat_gateway = false
  common_tags        = var.common_tags
}

module "security_groups" {
  source = "../../modules/security-groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id

  common_tags = var.common_tags
}

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment

  common_tags = var.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  environment  = var.environment

  image_tag_mutability = "IMMUTABLE"

  common_tags = var.common_tags
}

module "alb" {
  source = "../../modules/alb"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.vpc.vpc_id

  public_subnet_ids = module.vpc.public_subnet_ids

  alb_security_group_id = module.security_groups.alb_security_group_id

  target_port       = 80
  health_check_path = "/health"

  common_tags = var.common_tags
}

module "ecs" {
  source = "../../modules/ecs"

  project_name = var.project_name
  environment  = var.environment

  private_subnet_ids  = module.vpc.private_subnet_ids
  instance_subnet_ids = module.vpc.public_subnet_ids

  ecs_instance_security_group_id = module.security_groups.ecs_instance_security_group_id
  ecs_task_security_group_id     = module.security_groups.ecs_security_group_id

  ecs_instance_profile_name = module.iam.ecs_instance_profile_name

  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.iam.ecs_task_role_arn

  ecr_repository_url  = module.ecr.repository_url
  container_image_tag = "bootstrap"

  target_group_arn = module.alb.target_group_arn

  instance_type      = "t3.small"
  desired_task_count = 0

  enable_container_insights = false
  log_retention_days        = 7

  common_tags = var.common_tags
}

module "github_oidc" {
  source = "../../modules/github-oidc"

  project_name      = var.project_name
  environment       = var.environment
  github_repository = "mukeshelagandula09/aws-ecs-terraform-cicd"

  ecr_repository_arn          = module.ecr.repository_arn
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.iam.ecs_task_role_arn

  common_tags = var.common_tags
}
