# locals {
#   project_prefix          = data.terraform_remote_state.infra.outputs.project_prefix
#   build_suffix            = data.terraform_remote_state.infra.outputs.build_suffix
#   aws_region              = data.terraform_remote_state.infra.outputs.aws_region
#   host                    = data.terraform_remote_state.eks.outputs.cluster_endpoint
#   cluster_ca_certificate  = data.terraform_remote_state.eks.outputs.kubeconfig-certificate-authority-data
#   cluster_name            = data.terraform_remote_state.eks.outputs.cluster_name
#   app                     = format("%s-nap-%s", local.project_prefix, local.build_suffix)
# }

locals {
  project_prefix         = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-infra[0].outputs.project_prefix : var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.aws-infra[0].outputs.project_prefix : null
  build_suffix           = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-infra[0].outputs.build_suffix : var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.aws-infra[0].outputs.build_suffix : null
  host                   = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke[0].outputs.kubernetes_api_server_url : var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks[0].outputs.cluster_endpoint : null
  region                 = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-infra[0].outputs.gcp_region : null
  cluster_ca_certificate = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke[0].outputs.kubernetes_cluster_ca_certificate : var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks[0].outputs.kubeconfig-certificate-authority-data : null
  cluster_name           = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke[0].outputs.kubernetes_cluster_name : var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks[0].outputs.cluster_name : null
  cluster_token          = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gke[0].outputs.kubernetes_cluster_access_token : null
  cidr                   = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-infra[0].outputs.cidr : null
  kubectl_provider_alias = var.CLOUD_PROVIDER == "AWS" ? "aws" : "gcp"
}

locals {
  # project_prefix          = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.aws-infra.outputs.project_prefix : null
  # build_suffix            = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.aws-infra.outputs.build_suffix : null
  # cluster_name            = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks.outputs.cluster_name : null  # Single definition
  ebs_csi_driver_role_arn = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks[0].outputs.ebs_csi_driver_role_arn : null
  cluster_endpoint        = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks[0].outputs.cluster_endpoint : null
  aws_region              = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.aws-infra[0].outputs.aws_region : null
  # host                    = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks.outputs.cluster_endpoint : null
  # cluster_ca_certificate  = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks.outputs.kubeconfig-certificate-authority-data : null
  app                     = var.CLOUD_PROVIDER == "AWS" ? format("%s-nap-%s", local.project_prefix, local.build_suffix) : null
}