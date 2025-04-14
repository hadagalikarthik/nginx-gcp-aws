provider "aws" {
  region = local.aws_region
  alias = "aws"
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks[0].outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks[0].outputs.kubeconfig-certificate-authority-data)
  token                  = data.aws_eks_cluster_auth.auth[0].token
  alias                  = "aws"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.terraform_remote_state.eks[0].outputs.cluster_name
    ]
  }
}

provider "helm" {
  alias                  = "aws"
  kubernetes {
    host                   = data.terraform_remote_state.eks[0].outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks[0].outputs.kubeconfig-certificate-authority-data)
    token                  = data.aws_eks_cluster_auth.auth[0].token
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        data.terraform_remote_state.eks[0].outputs.cluster_name
      ]
    }
  }
}

provider "kubectl" {
  host                   = data.terraform_remote_state.eks[0].outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks[0].outputs.kubeconfig-certificate-authority-data)
  token                  = data.aws_eks_cluster_auth.auth[0].token
  load_config_file       = false
  alias                  = "aws"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.terraform_remote_state.eks[0].outputs.cluster_name
    ]
  }
}