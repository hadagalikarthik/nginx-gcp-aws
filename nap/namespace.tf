resource "kubernetes_namespace" "nginx-ingress" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create AWS instance when CLOUD_PROVIDER is AWS
  provider = AWS
  metadata {
    name = "nginx-ingress"
  }
}
resource "kubernetes_namespace" "monitoring" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create AWS instance when CLOUD_PROVIDER is AWS
  provider = AWS
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "nginx-ingress" {
  count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create AWS instance when CLOUD_PROVIDER is AWS
  provider = GCP
  metadata {
    name = "nginx-ingress"
  }
}
resource "kubernetes_namespace" "monitoring" {
  count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create AWS instance when CLOUD_PROVIDER is AWS
  provider = GCP
  metadata {
    name = "monitoring"
  }
}