resource "helm_release" "aws-prometheus" {
    count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
    provider = helm.aws
    name = format("%s-pro-%s", local.project_prefix, local.build_suffix)
    repository = "https://prometheus-community.github.io/helm-charts"
    chart = "prometheus"
    #version = "27.3.0"
    namespace = kubernetes_namespace.aws-monitoring.metadata[0].name
    values = [file("./charts/prometheus/values.yaml")]
}

resource "helm_release" "gcp-prometheus" {
    count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0
    provider = helm.gcp
    name = format("%s-pro-%s", local.project_prefix, local.build_suffix)
    repository = "https://prometheus-community.github.io/helm-charts"
    chart = "prometheus"
    #version = "27.3.0"
    namespace = kubernetes_namespace.gcp-monitoring.metadata[0].name
    values = [file("./charts/prometheus/values.yaml")]
}