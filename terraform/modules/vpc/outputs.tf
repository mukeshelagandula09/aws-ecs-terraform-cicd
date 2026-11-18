
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "nat_gateway_ids" {
  description = "IDs of NAT Gateways"
  value       = aws_nat_gateway.main[*].id
}

output "availability_zones" {
  description = "Configured availability zones"
  value       = var.availability_zones
}


output "private_route_table_ids" {
  description = "Private route table IDs"
  value       = values(aws_route_table.private)[*].id
}
