
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where endpoints will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for interface endpoints"
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "Private route table IDs for the S3 gateway endpoint"
  type        = list(string)
}

variable "ecs_instance_security_group_id" {
  description = "Security group attached to ECS EC2 instances"
  type        = string
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
