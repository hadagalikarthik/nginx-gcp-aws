resource "kubernetes_secret" "aws-nginx_license" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
  provider = kubernetes.aws
  metadata {
    name      = "license-token"
    namespace = kubernetes_namespace.aws-nginx-ingress[0].metadata[0].name
  }

  data = {
    "license.jwt" = var.nginx_jwt
  }

  type = "nginx.com/license"
}

resource "kubernetes_secret" "aws-docker-registry" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
  provider = kubernetes.aws
  metadata {
    name      = "regcred"
    namespace = kubernetes_namespace.aws-nginx-ingress[0].metadata[0].name
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