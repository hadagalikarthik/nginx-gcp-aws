# output "external_name" {
#     value = var.CLOUD_PROVIDER == "GCP" ? try(data.kubernetes_service_v1.nginx-service.status.0.load_balancer.0.ingress.0.hostname, null)
# }

output "external_name" {
  value = lookup(
    {
      "GCP" = try(data.kubernetes_service_v1.gcp-nginx-service[0].status.0.load_balancer.0.ingress.0.ip, null)
      "AWS" = try(data.kubernetes_service_v1.aws-nginx-service[0].status.0.load_balancer.0.ingress.0.hostname, null)
    },
    var.CLOUD_PROVIDER,
  )
}

# output "external_port" {
#     value = try(data.kubernetes_service_v1.nginx-service.spec.0.port.0.port, null)
# }

output "external_port" {
  value = lookup(
    {
      "GCP" = try(data.kubernetes_service_v1.gcp-nginx-service[0].spec.0.port.0.port, null)
      "AWS" = try(data.kubernetes_service_v1.aws-nginx-service[0].spec.0.port.0.port, null)
    },
    var.CLOUD_PROVIDER,
  )
}

output "origin_source" {
    value = "nap"
}

# output "nap_deployment_name" {
#     value = try (helm_release.nginx-plus-ingress.name)
#     sensitive = true
# }

output "nap_deployment_name" {
  value = lookup(
    {
      "GCP" = try (helm_release.gcp-nginx-plus-ingress[0].name)
      "AWS" = try (helm_release.aws-nginx-plus-ingress[0].name)
    },
    var.CLOUD_PROVIDER,
  )
  sensitive = true
}
# output "external_name" {
#     value = try(data.kubernetes_service_v1.nginx-service.status.0.load_balancer.0.ingress.0.ip, null)
# }

# output "external_port" {
#     value = try(data.kubernetes_service_v1.nginx-service.spec.0.port.0.port, null)
# }
#
# output "origin_source" {
#     value = "nap"
# }
#
# output "nap_deployment_name" {
#     value = try (helm_release.nginx-plus-ingress.name)
#     sensitive = true
# }

