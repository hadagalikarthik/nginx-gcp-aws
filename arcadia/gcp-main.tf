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

######################################################
####################### GCP ##########################
######################################################

resource "kubernetes_service" "gcp-main" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  provider = kubernetes.gcp
  metadata {
    name = "main"
    labels = {
      app = "main"
      service = "main"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }
    selector = {
      app = "main"
    }
    type = "ClusterIP"
  }
}
resource "kubernetes_service" "gcp-backend" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  provider = kubernetes.gcp
  metadata {
    name = "backend"
    labels = {
      app = "backend"
      service = "backend"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }
    selector = {
      app = "backend"
    }
    type = "ClusterIP"
  }
}
resource "kubernetes_service" "gcp-app_2" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  provider = kubernetes.gcp
  metadata {
    name = "app2"
    labels = {
      app = "app2"
      service = "app2"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }
    selector = {
      app = "app2"
    }
    type = "ClusterIP"
  }
}
resource "kubernetes_service" "gcp-app_3" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  provider = kubernetes.gcp
  metadata {
    name = "app3"
    labels = {
      app = "app3"
      service = "app3"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }
    selector = {
      app = "app3"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_manifest" "gcp-arcadia_virtualserver" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  provider = kubernetes.gcp
  manifest = {
    apiVersion = "k8s.nginx.org/v1"
    kind       = "VirtualServer"
    metadata = {
      name      = "arcadia-virtualserver"
      namespace = "default"
    }
    spec = {
      host = local.external_name

      # Reference the WAF policy
      policies = [
        {
          name      = "waf-policy"  # Name of the WAF policy
          namespace = "default"     # Namespace where the WAF policy is deployed
        }
      ]

      upstreams = [
        {
          name    = "main-upstream"
          service = kubernetes_service.gcp-main[0].metadata[0].name
          port    = 80
        },
        {
          name    = "backend-upstream"
          service = kubernetes_service.gcp-backend[0].metadata[0].name
          port    = 80
        },
        {
          name    = "app2-upstream"
          service = kubernetes_service.gcp-app_2[0].metadata[0].name
          port    = 80
        },
        {
          name    = "app3-upstream"
          service = kubernetes_service.gcp-app_3[0].metadata[0].name
          port    = 80
        }
      ]
      routes = [
        {
          path = "/"
          action = {
            pass = "main-upstream"
          }
        },
        {
          path = "/files"
          action = {
            pass = "backend-upstream"
          }
        },
        {
          path = "/api"
          action = {
            pass = "app2-upstream"
          }
        },
        {
          path = "/app3"
          action = {
            pass = "app3-upstream"
          }
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "gcp_waf_policy" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  provider = kubernetes.gcp
  manifest = {
    apiVersion = "k8s.nginx.org/v1"
    kind       = "Policy"
    metadata = {
      name      = "waf-policy"
      namespace = "default"  # Replace with your desired namespace
    }
    spec = {
      waf = {
        enable   = true
        apBundle = "compiled_policy.tgz"
      }
    }
  }
}