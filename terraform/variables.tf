variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "cluster_name" {
  description = "ECS Cluster name"
  type        = string
}

variable "service_name" {
  description = "ECS Service name"
  type        = string
}

variable "task_family" {
  description = "ECS Task definition family"
  type        = string
}

variable "initial_image" {
  description = "Initial Docker image to deploy"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS tasks"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for ECS tasks"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP to ECS tasks"
  type        = bool
}

# ALB Variables
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "lemon-alb"
}

variable "alb_subnets" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "alb_security_group_ids" {
  description = "List of security group IDs for ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for ALB target group"
  type        = string
}

variable "container_port" {
  description = "Port on which container listens"
  type        = number
  default     = 8080
}
