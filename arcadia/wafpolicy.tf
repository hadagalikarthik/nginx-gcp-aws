resource "kubernetes_manifest" "aws_waf_policy" {
  count = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is AWS
  provider = kubernetes.aws
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