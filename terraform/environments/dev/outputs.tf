
output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "ECR repository ARN"
  value       = module.ecr.repository_arn
}

output "ecs_instance_profile_name" {
  description = "ECS EC2 instance profile name"
  value       = module.iam.ecs_instance_profile_name
}

output "ecs_task_execution_role_arn" {
  description = "ECS task execution role ARN"
  value       = module.iam.ecs_task_execution_role_arn
}

output "ecs_task_role_arn" {
  description = "ECS task role ARN"
  value       = module.iam.ecs_task_role_arn
}

output "github_actions_role_arn" {
  description = "IAM role ARN for GitHub Actions"
  value       = module.github_oidc.github_actions_role_arn
}

output "github_oidc_provider_arn" {
  description = "GitHub OIDC provider ARN"
  value       = module.github_oidc.github_oidc_provider_arn
}
