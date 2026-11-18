
output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Application Load Balancer Route53 hosted zone ID"
  value       = aws_lb.main.zone_id
}

output "target_group_arn" {
  description = "Application target group ARN"
  value       = aws_lb_target_group.app.arn
}

output "alb_listener_arn" {
  description = "HTTP listener ARN"
  value       = aws_lb_listener.http.arn
}
