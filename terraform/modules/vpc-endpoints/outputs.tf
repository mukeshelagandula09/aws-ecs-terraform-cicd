
output "interface_endpoint_ids" {
  description = "Map of interface VPC endpoint IDs"
  value       = { for key, endpoint in aws_vpc_endpoint.interface : key => endpoint.id }
}

output "s3_endpoint_id" {
  description = "S3 Gateway endpoint ID"
  value       = aws_vpc_endpoint.s3.id
}

output "endpoint_security_group_id" {
  description = "VPC endpoint security group ID"
  value       = aws_security_group.endpoints.id
}
