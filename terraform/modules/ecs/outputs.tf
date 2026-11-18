
output "ecs_cluster_id" {
  description = "ECS cluster ID"
  value       = aws_ecs_cluster.main.id
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.app.name
}

output "ecs_service_arn" {
  description = "ECS service ARN"
  value       = aws_ecs_service.app.id
}

output "ecs_task_definition_arn" {
  description = "ECS task definition ARN"
  value       = aws_ecs_task_definition.app.arn
}

output "ecs_asg_name" {
  description = "ECS Auto Scaling Group name"
  value       = aws_autoscaling_group.ecs.name
}

output "ecs_capacity_provider_name" {
  description = "ECS capacity provider name"
  value       = aws_ecs_capacity_provider.main.name
}

output "ecs_log_group_name" {
  description = "Application CloudWatch log group"
  value       = aws_cloudwatch_log_group.app.name
}

output "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  value       = aws_ecs_cluster.main.arn
}