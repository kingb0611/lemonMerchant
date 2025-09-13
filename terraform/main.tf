terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ECS Cluster
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

# IAM role for ECS task execution
resource "aws_iam_role" "task_execution" {
  name = "${var.cluster_name}-ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "task_execution_attach" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAM role for ECS task (app)
resource "aws_iam_role" "task_role" {
  name = "${var.cluster_name}-ecsTaskRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

# CloudWatch log group
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.service_name}"
  retention_in_days = 14
}

# Task definition (template, Jenkins will register new revisions later)
resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = aws_iam_role.task_execution.arn
  task_role_arn      = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    {
      name      = var.service_name
      image     = var.initial_image
      essential = true
      portMappings = [
        {
          containerPort = 9090
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
    assign_public_ip = var.assign_public_ip
  }

  lifecycle {
    ignore_changes = [task_definition] # Jenkins will register new revisions and update service
  }
}
