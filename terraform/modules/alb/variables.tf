
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB target group"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the internet-facing ALB"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "An internet-facing ALB requires at least two subnets."
  }
}

variable "alb_security_group_id" {
  description = "Security group ID attached to the ALB"
  type        = string
}

variable "target_port" {
  description = "Application container port"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Application health check endpoint"
  type        = string
  default     = "/health"
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
