data "terraform_remote_state" "aws-infra" {
  count = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is AWS
  backend = "s3"
  config = {
    bucket = var.AWS_S3_BUCKET_NAME       # Your S3 bucket name
    key    = "infra/terraform.tfstate"       # Path to infra's state file
    region = var.AWS_REGION                    # AWS region
  }
}

# Read eks state from S3
data "terraform_remote_state" "eks" {
  count = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is AWS
  backend = "s3"
  config = {
    bucket =  var.AWS_S3_BUCKET_NAME        # Your S3 bucket name
    key    = "eks-cluster/terraform.tfstate" # Path to EKS state file
    region = var.AWS_REGION                    # AWS region
  }
}

data "aws_eks_cluster_auth" "auth" {
  count = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is AWS
  name = data.terraform_remote_state.eks[0].outputs.cluster_name
}

data "kubernetes_service_v1" "aws-nginx-service" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
  metadata {
    name      = try(format("%s-%s-controller", helm_release.aws-nginx-plus-ingress.name, helm_release.aws-nginx-plus-ingress.chart))
    namespace = try(helm_release.aws-nginx-plus-ingress.namespace)
  }
}

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
    prefix    = "gke/terraform.tfstate" # Path to EKS state file
  }
}

data "kubernetes_service_v1" "gcp-nginx-service" {
  count    = var.CLOUD_PROVIDER == "GCP" ? 1 : 0
  metadata {
    name      = try(format("%s-%s-controller", helm_release.gcp-nginx-plus-ingress.name, helm_release.gcp-nginx-plus-ingress.chart))
    namespace = try(helm_release.gcp-nginx-plus-ingress.namespace)
  }
}