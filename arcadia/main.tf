provider "aws" {
  alias = "aws"
  region = local.aws_region
}

provider "kubernetes" {
  alias                  = "aws"
  host                   = local.host
  cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.auth[0].token
}

provider "helm" {
  alias                  = "aws"
  kubernetes {
    host  = local.host
    cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
    token = data.aws_eks_cluster_auth.auth[0].token
  }
}

provider "google" {
  alias = "gcp"
  region = local.region
}

provider "kubernetes" {
  alias                  = "gcp"
  host                   = local.host
  cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
  token                  = local.cluster_token
}

provider "helm" {
  alias                  = "gcp"
  kubernetes {
    host                   = local.host
    cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
    token                  = local.cluster_token
  }
}