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

resource "helm_release" "gcp-grafana" {
  count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0
  provider = helm.gcp
  name = format("%s-gfa-%s", local.project_prefix, local.build_suffix)
  repository = "https://grafana.github.io/helm-charts"
  chart = "grafana"
  version = "6.50.7"
  namespace = kubernetes_namespace.gcp-monitoring[0].metadata[0].name
  values = [file("./charts/grafana/values.yaml")]
}

resource "helm_release" "gcp-nginx-plus-ingress" {
  count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0
  provider = helm.gcp
  name       = format("%s-nap-%s", local.project_prefix, local.build_suffix)
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  version    = "2.0.1"
  namespace  = kubernetes_namespace.gcp-nginx-ingress[0].metadata[0].name
  values     = [file("./charts/nginx-app-protect/values.yaml")]
  timeout    = 600

  depends_on = [
    kubernetes_secret.gcp-docker-registry
  ]
}

resource "helm_release" "gcp-prometheus" {
    count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0
    provider = helm.gcp
    name = format("%s-pro-%s", local.project_prefix, local.build_suffix)
    repository = "https://prometheus-community.github.io/helm-charts"
    chart = "prometheus"
    #version = "27.3.0"
    namespace = kubernetes_namespace.gcp-monitoring[0].metadata[0].name
    values = [file("./charts/prometheus/values.yaml")]
}

resource "kubernetes_namespace" "gcp-nginx-ingress" {
  count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0
  provider = kubernetes.gcp
  metadata {
    name = "nginx-ingress"
  }
}
resource "kubernetes_namespace" "gcp-monitoring" {
  count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0
  provider = kubernetes.gcp
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_secret" "gcp-nginx_license" {
  count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0
  provider = kubernetes.gcp
  metadata {
    name      = "license-token"
    namespace = kubernetes_namespace.gcp-nginx-ingress[0].metadata[0].name
  }
  data = {
    "license.jwt" = var.nginx_jwt
  }
  type = "nginx.com/license"
}

resource "kubernetes_secret" "gcp-docker-registry" {
  count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0
  provider = kubernetes.gcp
  metadata {
    name      = "regcred"
    namespace = kubernetes_namespace.gcp-nginx-ingress[0].metadata[0].name
  }
  type = "kubernetes.io/dockerconfigjson"
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.nginx_registry}" = {
          "username" = var.nginx_jwt,  # Use the JWT token as the username
          "password" = "none",  # Set password to "none"
          "auth"     = base64encode("${var.nginx_jwt}:none")  # Encode "<jwt-token>:none"
        }
      }
    })
  }
}

# resource "kubernetes_storage_class_v1" "gce_csi" {
#   metadata {
#     name = "standard-sc"
#     annotations = {
#       "storageclass.kubernetes.io/is-default-class" = "true"
#     }
#   }
#
#   # Provisioner for GCP Persistent Disks (GCE PD)
#   storage_provisioner = "kubernetes.io/gce-pd"
#
#   reclaim_policy = "Delete"  # Automatically delete volumes when they are no longer used.
#
#   parameters = {
#     type   = "pd-standard"   # This is the default disk type for GCP Persistent Disks.
#     fsType = "ext4"          # Filesystem type for the disk.
#   }
#
#   allow_volume_expansion = true
#
#   # Volume binding mode - control when the volume should be provisioned.
#   volume_binding_mode = "WaitForFirstConsumer"
# }
