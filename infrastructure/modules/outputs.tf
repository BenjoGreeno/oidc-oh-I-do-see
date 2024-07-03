output "ecs_cluster_id" {
  value = aws_ecs_cluster.example.id
}

output "ecs_service_name" {
  value = aws_ecs_service.api_service.name
}

output "ecs_task_definition" {
  value = aws_ecs_task_definition.api.arn
}

output "vpc_id" {
  value = aws_vpc.testApp01-vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "security_group_id" {
  value = aws_security_group.ecs_sg.id
}
