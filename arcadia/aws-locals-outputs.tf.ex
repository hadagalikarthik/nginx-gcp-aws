locals {
  external_name         = try(var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.aws-nap[0].outputs.external_name : null)
  project_prefix         = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.aws-infra[0].outputs.project_prefix : null
  build_suffix           = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.aws-infra[0].outputs.build_suffix : null
  host                   = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks[0].outputs.cluster_endpoint : null
  cluster_ca_certificate = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks[0].outputs.kubeconfig-certificate-authority-data : null
  cluster_name           = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks[0].outputs.cluster_name : null
  kubectl_provider_alias = var.CLOUD_PROVIDER == "AWS" ? "aws" : "gcp"
}

locals {
  # project_prefix          = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.aws-infra.outputs.project_prefix : null
  # build_suffix            = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.aws-infra.outputs.build_suffix : null
  # cluster_name            = var.CLOUD_PROVIDER == "AWS" ? data.terraforma.terraform_remote_state._remote_state.eks.outputs.cluster_name : null  # Single definition
  ebs_csi_driver_role_arn = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks[0].outputs.ebs_csi_driver_role_arn : null
  cluster_endpoint        = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks[0].outputs.cluster_endpoint : null
  aws_region              = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.aws-infra[0].outputs.aws_region : null
  # host                    = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks.outputs.cluster_endpoint : null
  # cluster_ca_certificate  = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks.outputs.kubeconfig-certificate-authority-data : null
  app                     = var.CLOUD_PROVIDER == "AWS" ? format("%s-nap-%s", local.project_prefix, local.build_suffix) : null
}

output "external_name" {
  description = "The external hostname of NGINX Ingress from NAP"
  value = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.aws-nap[0].outputs.external_name : null
}
