provider "google" {
    region = local.region
    alias = "gcp"
}

provider "kubernetes" {
  host                   = local.host
  cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
  token                  = local.cluster_token
  alias                  = "gcp"
  # Optional: Using exec for kubectl authentication
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gcloud"
    args = concat(
      ["container", "clusters", "get-credentials", local.cluster_name],
      local.region != null ? ["--region", local.region] : []
    )
  }
}

provider "helm" {
  alias                  = "gcp"
  kubernetes {
    host                   = local.host
    cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
    token                  = local.cluster_token

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "gcloud"
      args = concat(
        ["container", "clusters", "get-credentials", local.cluster_name],
        local.region != null ? ["--region", local.region] : []
      )
    }
  }
}

provider "kubectl" {
    host                    = local.host
    cluster_ca_certificate  = base64decode(local.cluster_ca_certificate)
    token                   = local.cluster_token
    load_config_file        = false
    alias                  = "gcp"
    exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gcloud"
    args = concat(
      ["container", "clusters", "get-credentials", local.cluster_name],
      local.region != null ? ["--region", local.region] : []
    )
  }
}