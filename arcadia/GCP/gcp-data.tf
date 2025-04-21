data "terraform_remote_state" "gcp-infra" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  backend = "gcs"
  config = {
    bucket = var.GCP_BUCKET_NAME       # Your S3 bucket name
    prefix    = "infra/terraform.tfstate"       # Path to infra's state file
  }
}

data "terraform_remote_state" "gke" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  backend = "gcs"
  config = {
    bucket =  var.GCP_BUCKET_NAME        # Your S3 bucket name
    prefix    = "cluster/terraform.tfstate" # Path to EKS state file
  }
}

data "terraform_remote_state" "gcp-nap" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  backend = "gcs"
  config = {
    bucket =  var.GCP_BUCKET_NAME        # Your S3 bucket name
    prefix    = "nap/terraform.tfstate" # Path to EKS state file
  }
}

locals {
  external_name         = try(var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-nap[0].outputs.external_name : null)
  project_prefix         = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-infra[0].outputs.project_prefix : null
  build_suffix           = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-infra[0].outputs.build_suffix : null
  host                   = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke[0].outputs.kubernetes_api_server_url : null
  region                 = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-infra[0].outputs.gcp_region : null
  cluster_ca_certificate = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke[0].outputs.kubernetes_cluster_ca_certificate : null
  cluster_name           = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke[0].outputs.kubernetes_cluster_name : null
  cluster_token          = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke[0].outputs.kubernetes_cluster_access_token : null
  cidr                   = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-infra[0].outputs.cidr : null
  kubectl_provider_alias = var.CLOUD_PROVIDER == "AWS" ? "aws" : "gcp"
}

output "external_name" {
  description = "The external hostname of NGINX Ingress from NAP"
  value = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-nap[0].outputs.external_name : null
}