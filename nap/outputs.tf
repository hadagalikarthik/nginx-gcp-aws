output "external_name" {
  value = var.CLOUD_PROVIDER == "GCP" ? data.kubernetes_service_v1.gcp-nginx-service[0].status.0.load_balancer.0.ingress.0.ip : var.CLOUD_PROVIDER == "AWS" ? data.kubernetes_service_v1.aws-nginx-service[0].status.0.load_balancer.0.ingress.0.hostname : null
}

output "external_port" {
  value = var.CLOUD_PROVIDER == "GCP" ? data.kubernetes_service_v1.gcp-nginx-service[0].spec.0.port.0.port : var.CLOUD_PROVIDER == "AWS" ? data.kubernetes_service_v1.aws-nginx-service[0].spec.0.port.0.port : null
}

output "origin_source" {
    value = "nap"
}

output "nap_deployment_name" {
  value = var.CLOUD_PROVIDER == "GCP" ? helm_release.gcp-nginx-plus-ingress[0].name : var.CLOUD_PROVIDER == "AWS" ? helm_release.aws-nginx-plus-ingress[0].name : null
  sensitive = true
}