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

resource "kubernetes_deployment" "gcp-main" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  provider = kubernetes.gcp
  metadata {
    name = "main"
    labels = {
      app = "main"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "main"
      }
    }
    template {
      metadata {
        labels = {
          app = "main"
        }
      }
      spec {
        container {
          name  = "main"
          image = "registry.gitlab.com/arcadia-application/main-app/mainapp:latest"

          port {
            container_port = 80
          }
          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}
resource "kubernetes_deployment" "gcp-backend" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  provider = kubernetes.gcp
  metadata {
    name = "backend"
    labels = {
      app = "backend"
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "backend"
      }
    }
    template {
      metadata {
        labels = {
          app = "backend"
        }
      }
      spec {
        container {
          name  = "backend"
          image = "registry.gitlab.com/arcadia-application/back-end/backend:latest"
          port {
            container_port = 80
          }
          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}
resource "kubernetes_deployment" "gcp-app_2" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  provider = kubernetes.gcp
  metadata {
    name = "app2"
    labels = {
      app = "app2"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "app2"
      }
    }
    template {
      metadata {
        labels = {
          app = "app2"
        }
      }
      spec {
        container {
          name  = "app2"
          image = "registry.gitlab.com/arcadia-application/app2/app2:latest"
          port {
            container_port = 80
          }
          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}
resource "kubernetes_deployment" "gcp-app_3" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  provider = kubernetes.gcp
  metadata {
    name = "app3"
    labels = {
      app = "app3"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "app3"
      }
    }

    template {
      metadata {
        labels = {
          app = "app3"
        }
      }

      spec {
        container {
          name  = "app3"
          image = "registry.gitlab.com/arcadia-application/app3/app3:latest"
          port {
            container_port = 80
          }
          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}