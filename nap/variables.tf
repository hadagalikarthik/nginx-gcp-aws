# variable "CLOUD_PROVIDER" {
#   description = "The cloud provider to use (either AWS/Azure/GCP) set in workflow file"
#   type        = string
# }

# NGINX Configuration
variable "nginx_registry" {
  type        = string
  description = "NGINX Docker registry"
  default     = "private-registry.nginx.com"
}

variable "nginx_pwd" {
  type        = string
  description = "Password for NGINX (if required)"
  default     = "none"
}

variable "workspace_path" {
  description = "The path to the workspace directory"
  type        = string
}

variable "nginx_jwt" {
  description = "The JWT token for NGINX"
  type        = string
  sensitive   = true  # Mark as sensitive to avoid exposing it in logs
}

variable "AWS_REGION" {
  description = "aws region"
  type        = string
  default     = ""
}

variable "AWS_S3_BUCKET_NAME" {
  description = "aws s3 bucket name"
  type        = string
  default     = ""
}

variable "GCP_REGION" {
  description = "GCP region name"
  type        = string
}

variable "GCP_BUCKET_NAME" {
  description = "GCP bucket name"
  type    = string
}