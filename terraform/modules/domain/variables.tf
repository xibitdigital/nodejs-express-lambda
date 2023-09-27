variable "lambda_repo_root_path" {
  type        = string
  description = "solution root path"
}

variable "lambda_function_name" {
  type        = string
  description = "lambda function name"
}

variable "lambda_handler" {
  type        = string
  description = "lambda handler"
}

variable "lambda_prefix" {
  type        = string
  description = "lambda prefix"
}

variable "lambda_runtime" {
  type        = string
  description = "lambda runtime"
}

variable "lambda_identity_timeout" {
  type        = string
  description = "lambda lambda_identity_timeout"
}

### common vars
variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "environment"
}
