data "terraform_remote_state" "aws-infra" {
  count = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is AWS
  backend = "s3"
  config = {
    bucket = var.AWS_S3_BUCKET_NAME       # Your S3 bucket name
    key    = "infra/terraform.tfstate"       # Path to infra's state file
    region = var.AWS_REGION                    # AWS region
  }
}

# Read eks state from S3
data "terraform_remote_state" "eks" {
  count = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is AWS
  backend = "s3"
  config = {
    bucket =  var.AWS_S3_BUCKET_NAME        # Your S3 bucket name
    key    = "cluster/terraform.tfstate" # Path to EKS state file
    region = var.AWS_REGION                    # AWS region
  }
}

data "aws_eks_cluster_auth" "auth" {
  count = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is AWS
  provider = aws.aws
  name = data.terraform_remote_state.eks[0].outputs.cluster_name
}

data "kubernetes_service_v1" "aws-nginx-service" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
  provider = kubernetes.aws
  metadata {
    name      = try(format("%s-%s-controller", helm_release.aws-nginx-plus-ingress[0].name, helm_release.aws-nginx-plus-ingress[0].chart))
    namespace = try(helm_release.aws-nginx-plus-ingress[0].namespace)
  }
}

locals {
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
  # cluster_name            = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks.outputs.cluster_name : null  # Single definition
  ebs_csi_driver_role_arn = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks[0].outputs.ebs_csi_driver_role_arn : null
  cluster_endpoint        = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks[0].outputs.cluster_endpoint : null
  aws_region              = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.aws-infra[0].outputs.aws_region : null
  # host                    = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks.outputs.cluster_endpoint : null
  # cluster_ca_certificate  = var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.eks.outputs.kubeconfig-certificate-authority-data : null
  app                     = var.CLOUD_PROVIDER == "AWS" ? format("%s-nap-%s", local.project_prefix, local.build_suffix) : null
}

output "external_name" {
  value = var.CLOUD_PROVIDER == "AWS" ? data.kubernetes_service_v1.aws-nginx-service[0].status.0.load_balancer.0.ingress.0.hostname : null
}

output "external_port" {
  value = var.CLOUD_PROVIDER == "AWS" ? data.kubernetes_service_v1.aws-nginx-service[0].spec.0.port.0.port : null
}

output "origin_source" {
    value = "nap"
}

output "nap_deployment_name" {
  value = var.CLOUD_PROVIDER == "AWS" ? helm_release.aws-nginx-plus-ingress[0].name : null
  sensitive = true
}