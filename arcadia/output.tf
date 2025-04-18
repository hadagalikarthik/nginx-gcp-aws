output "external_name" {
  description = "The external hostname of NGINX Ingress from NAP"
  value = var.CLOUD_PROVIDER == "GCP" ? data.terraform_remote_state.gcp-nap[0].outputs.external_name : var.CLOUD_PROVIDER == "AWS" ? data.terraform_remote_state.aws-nap[0].outputs.external_name : null
}
