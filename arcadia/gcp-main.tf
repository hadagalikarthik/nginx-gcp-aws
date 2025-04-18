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