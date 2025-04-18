output "external_name" {
  description = "The external hostname of NGINX Ingress from NAP"
  # value       = data.terraform_remote_state.nap.outputs.external_name
  value = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-nap.outputs.external_name : var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.aws-nap.outputs.external_name : null
}
