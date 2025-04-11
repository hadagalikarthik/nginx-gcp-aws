resource "helm_release" "aws-nginx-plus-ingress" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
  provider = helm.aws
  name       = format("%s-nap-%s", local.project_prefix, local.build_suffix)
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  version    = "2.0.1"
  namespace  = kubernetes_namespace.aws-nginx-ingress.metadata[0].name
  values     = [file("./charts/nginx-app-protect/values.yaml")]
  timeout    = 600

  depends_on = [
    kubernetes_secret.aws-docker-registry
  ]
}

resource "helm_release" "gcp-nginx-plus-ingress" {
  count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0
  provider = helm.gcp
  name       = format("%s-nap-%s", local.project_prefix, local.build_suffix)
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  version    = "2.0.1"
  namespace  = kubernetes_namespace.gcp-nginx-ingress.metadata[0].name
  values     = [file("./charts/nginx-app-protect/values.yaml")]
  timeout    = 600

  depends_on = [
    kubernetes_secret.gcp-docker-registry
  ]
}