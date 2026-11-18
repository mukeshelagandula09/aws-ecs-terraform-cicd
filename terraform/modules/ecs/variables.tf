
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets for ECS EC2 instances and tasks"
  type        = list(string)
}

variable "ecs_instance_security_group_id" {
  description = "Security group for ECS EC2 instances"
  type        = string
}

variable "ecs_task_security_group_id" {
  description = "Security group for ECS task ENIs"
  type        = string
}

variable "ecs_instance_profile_name" {
  description = "IAM instance profile for ECS EC2 instances"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ECS task execution role ARN"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "Application task role ARN"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}

variable "container_image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "bootstrap"
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for ECS capacity"
  type        = string
  default     = "t3.small"
}

variable "desired_task_count" {
  description = "Initial desired ECS task count"
  type        = number
  default     = 0
}

variable "enable_container_insights" {
  description = "Enable ECS Container Insights"
  type        = bool
  default     = false
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}

variable "instance_subnet_ids" {
  description = "Public subnet IDs for ECS EC2 instances"
  type        = list(string)
}