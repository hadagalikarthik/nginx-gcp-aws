variable "CLOUD_PROVIDER" {
  description = "The cloud provider to use (either AWS/Azure/GCP) set in workflow file"
  type        = string
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