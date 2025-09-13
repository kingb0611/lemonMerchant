variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "cluster_name" {
  type        = string
  description = "ECS cluster name"
  default     = "lemon-cluster"
}

variable "service_name" {
  type        = string
  description = "ECS service name"
  default     = "lemon-service"
}

variable "task_family" {
  type        = string
  description = "Task definition family"
  default     = "lemonmerchant"
}

variable "initial_image" {
  type        = string
  description = "Initial docker image (Jenkins will update later)"
  default     = "kbkn1106/lemonmerchant:latest"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for ECS tasks"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups for ECS tasks"
}

variable "assign_public_ip" {
  type        = bool
  description = "Assign public IP to Fargate task?"
  default     = true
}
