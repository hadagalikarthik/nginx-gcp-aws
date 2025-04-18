locals {
  project_prefix         = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.infra.outputs.project_prefix : null
  build_suffix           = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.infra.outputs.build_suffix : null
  host                   = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke.outputs.kubernetes_api_server_url : null
  region                 = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.infra.outputs.gcp_region : null
  cluster_ca_certificate = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke.outputs.kubernetes_cluster_ca_certificate : null
  cluster_name           = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke.outputs.kubernetes_cluster_name : null
  cluster_token          = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke.outputs.kubernetes_cluster_access_token : null
  cidr                   = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.infra.outputs.cidr : null
}

locals {
  project_prefix          = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.infra.outputs.project_prefix : null
  build_suffix            = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.infra.outputs.build_suffix : null
  cluster_name            = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks.outputs.cluster_name : null  # Single definition
  ebs_csi_driver_role_arn = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks.outputs.ebs_csi_driver_role_arn : null
  cluster_endpoint        = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks.outputs.cluster_endpoint : null
  aws_region              = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.infra.outputs.aws_region : null
  host                    = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks.outputs.cluster_endpoint : null
  cluster_ca_certificate  = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks.outputs.kubeconfig-certificate-authority-data : null
  app                     = var.CLOUD_PROVIDER == "AWS" ? format("%s-nap-%s", local.project_prefix, local.build_suffix) : null
}