data "terraform_remote_state" "gcp-infra" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  backend = "gcs"
  config = {
    bucket = var.GCP_BUCKET_NAME       # Your S3 bucket name
    prefix    = "infra/terraform.tfstate"       # Path to infra's state file
  }
}

# Read eks state from S3
data "terraform_remote_state" "gke" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  backend = "gcs"
  config = {
    bucket =  var.GCP_BUCKET_NAME        # Your S3 bucket name
    prefix    = "cluster/terraform.tfstate" # Path to EKS state file
  }
}

data "kubernetes_service_v1" "gcp-nginx-service" {
  count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0
  provider = kubernetes.gcp
  metadata {
    name      = try(format("%s-%s-controller", helm_release.gcp-nginx-plus-ingress[0].name, helm_release.gcp-nginx-plus-ingress[0].chart))
    namespace = try(helm_release.gcp-nginx-plus-ingress[0].namespace)
  }
}

# locals {
#   project_prefix         = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-infra[0].outputs.project_prefix : null
#   build_suffix           = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-infra[0].outputs.build_suffix :  null
#   host                   = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke[0].outputs.kubernetes_api_server_url : null
#   region                 = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-infra[0].outputs.gcp_region : null
#   cluster_ca_certificate = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke[0].outputs.kubernetes_cluster_ca_certificate : null
#   cluster_name           = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke[0].outputs.kubernetes_cluster_name : null
#   cluster_token          = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke[0].outputs.kubernetes_cluster_access_token : null
#   cidr                   = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-infra[0].outputs.cidr : null
# }
#
# output "external_name" {
#   value = var.CLOUD_PROVIDER == "GCP" ? data.kubernetes_service_v1.gcp-nginx-service[0].status.0.load_balancer.0.ingress.0.ip : null
# }
#
# output "external_port" {
#   value = var.CLOUD_PROVIDER == "GCP" ? data.kubernetes_service_v1.gcp-nginx-service[0].spec.0.port.0.port : null
# }
#
# output "origin_source" {
#     value = "nap"
# }
#
# output "nap_deployment_name" {
#   value = var.CLOUD_PROVIDER == "GCP" ? helm_release.gcp-nginx-plus-ingress[0].name : null
#   sensitive = true
# }