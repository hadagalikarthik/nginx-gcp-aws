resource "kubernetes_namespace" "aws-nginx-ingress" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create AWS instance when CLOUD_PROVIDER is AWS
  provider = kubernetes.aws
  metadata {
    name = "nginx-ingress"
  }
}
resource "kubernetes_namespace" "aws-monitoring" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create AWS instance when CLOUD_PROVIDER is AWS
  provider = kubernetes.aws
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "gcp-nginx-ingress" {
  count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create AWS instance when CLOUD_PROVIDER is AWS
  provider = kubernetes.gcp
  metadata {
    name = "nginx-ingress"
  }
}
resource "kubernetes_namespace" "gcp-monitoring" {
  count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create AWS instance when CLOUD_PROVIDER is AWS
  provider = kubernetes.gcp
  metadata {
    name = "monitoring"
  }
}