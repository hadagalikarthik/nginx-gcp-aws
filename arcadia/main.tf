provider "aws" {
  region = local.aws_region
  alias = "aws"
}

provider "kubernetes" {
  host                   = local.host
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks[0].outputs.kubeconfig-certificate-authority-data)
  token                  = data.aws_eks_cluster_auth.auth[0].token
  alias                  = "aws"
}

provider "helm" {
  alias                  = "aws"
  kubernetes {
      host  = local.host
      cluster_ca_certificate = base64decode(data.terraform_remote_state.eks[0].outputs.kubeconfig-certificate-authority-data)
      token = data.aws_eks_cluster_auth.auth[0].token
  }
}

provider "google" {
    region                  = local.region
    alias = "gcp"
}

provider "kubernetes" {
  host                   = local.host
  cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
  token                  = local.cluster_token
  alias                  = "gcp"
}

provider "helm" {
  alias                  = "gcp"
  kubernetes {
    host                   = local.host
    cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
    token                  = local.cluster_token
  }
}