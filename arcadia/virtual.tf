resource "kubernetes_manifest" "aws-arcadia_virtualserver" {
  count = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is AWS
  provider = kubernetes.aws
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
          service = kubernetes_service.aws-main.metadata[0].name
          port    = 80
        },
        {
          name    = "backend-upstream"
          service = kubernetes_service.aws-backend.metadata[0].name
          port    = 80
        },
        {
          name    = "app2-upstream"
          service = kubernetes_service.aws-app_2.metadata[0].name
          port    = 80
        },
        {
          name    = "app3-upstream"
          service = kubernetes_service.aws-app_3.metadata[0].name
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

######################################################
####################### GCP ##########################
######################################################

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
          service = kubernetes_service.gcp-main.metadata[0].name
          port    = 80
        },
        {
          name    = "backend-upstream"
          service = kubernetes_service.gcp-backend.metadata[0].name
          port    = 80
        },
        {
          name    = "app2-upstream"
          service = kubernetes_service.gcp-app_2.metadata[0].name
          port    = 80
        },
        {
          name    = "app3-upstream"
          service = kubernetes_service.gcp-app_3.metadata[0].name
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
