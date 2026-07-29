variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for deployment"
}

variable "ecr_repository_url" {
  type        = string
  default     = "260544023443.dkr.ecr.us-east-1.amazonaws.com/my-secure-go-app"
  description = "Full URL of the ECR repository"
}