
output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "ECS security group ID"
  value       = aws_security_group.ecs.id
}

output "ecs_instance_security_group_id" {
  description = "Security group for ECS EC2 instances"
  value       = aws_security_group.ecs_instance.id
}