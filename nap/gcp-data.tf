data "terraform_remote_state" "gcp-infra" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  backend = "gcs"
  config = {
    bucket = var.GCP_BUCKET_NAME       # Your S3 bucket name
    prefix    = "infra/terraform.tfstate"       # Path to infra's state file
  }
}

# Read eks state from S3
data "terraform_remote_state" "gke" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  backend = "gcs"
  config = {
    bucket =  var.GCP_BUCKET_NAME        # Your S3 bucket name
    prefix    = "cluster/terraform.tfstate" # Path to EKS state file
  }
}

data "kubernetes_service_v1" "gcp-nginx-service" {
  count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0
  provider = kubernetes.gcp
  metadata {
    name      = try(format("%s-%s-controller", helm_release.gcp-nginx-plus-ingress[0].name, helm_release.gcp-nginx-plus-ingress[0].chart))
    namespace = try(helm_release.gcp-nginx-plus-ingress[0].namespace)
  }
}