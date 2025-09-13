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
