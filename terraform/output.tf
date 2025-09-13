output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "task_execution_role_arn" {
  value = aws_iam_role.task_execution.arn
}

output "task_role_arn" {
  value = aws_iam_role.task_role.arn
}

output "log_group" {
  value = aws_cloudwatch_log_group.ecs.name
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
  description = "Public DNS name of the Application Load Balancer"
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.ecs_tg.arn
}