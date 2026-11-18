
output "ecs_instance_role_arn" {
  description = "ECS EC2 instance IAM role ARN"
  value       = aws_iam_role.ecs_instance.arn
}

output "ecs_instance_profile_name" {
  description = "ECS EC2 instance profile name"
  value       = aws_iam_instance_profile.ecs.name
}

output "ecs_task_execution_role_arn" {
  description = "ECS task execution IAM role ARN"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "ecs_task_role_arn" {
  description = "ECS application task IAM role ARN"
  value       = aws_iam_role.ecs_task.arn
}