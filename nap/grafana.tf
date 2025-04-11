resource "helm_release" "aws-grafana" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
  provider = helm.aws
  name = format("%s-gfa-%s", local.project_prefix, local.build_suffix)
  repository = "https://grafana.github.io/helm-charts"
  chart = "grafana"
  version = "6.50.7"
  namespace = kubernetes_namespace.aws-monitoring.metadata[0].name
  values = [file("./charts/grafana/values.yaml")]
}

resource "helm_release" "gcp-grafana" {
  count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0
  provider = helm.gcp
  name = format("%s-gfa-%s", local.project_prefix, local.build_suffix)
  repository = "https://grafana.github.io/helm-charts"
  chart = "grafana"
  version = "6.50.7"
  namespace = kubernetes_namespace.gcp-monitoring.metadata[0].name
  values = [file("./charts/grafana/values.yaml")]
}