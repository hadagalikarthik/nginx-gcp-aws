provider "aws" {
  region = local.aws_region
  alias = "aws"
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks[0].outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks[0].outputs.kubeconfig-certificate-authority-data)
  token                  = data.aws_eks_cluster_auth.auth[0].token
  alias                  = "aws"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.terraform_remote_state.eks[0].outputs.cluster_name
    ]
  }
}

provider "helm" {
  alias                  = "aws"
  kubernetes {
    host                   = data.terraform_remote_state.eks[0].outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks[0].outputs.kubeconfig-certificate-authority-data)
    token                  = data.aws_eks_cluster_auth.auth[0].token
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        data.terraform_remote_state.eks[0].outputs.cluster_name
      ]
    }
  }
}

provider "kubectl" {
  host                   = data.terraform_remote_state.eks[0].outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks[0].outputs.kubeconfig-certificate-authority-data)
  token                  = data.aws_eks_cluster_auth.auth[0].token
  load_config_file       = false
  alias                  = "aws"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.terraform_remote_state.eks[0].outputs.cluster_name
    ]
  }
}

resource "helm_release" "aws-grafana" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
  provider = helm.aws
  name = format("%s-gfa-%s", local.project_prefix, local.build_suffix)
  repository = "https://grafana.github.io/helm-charts"
  chart = "grafana"
  version = "6.50.7"
  namespace = kubernetes_namespace.aws-monitoring[0].metadata[0].name
  values = [file("../charts/grafana/values.yaml")]
}

resource "helm_release" "aws-nginx-plus-ingress" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
  provider = helm.aws
  name       = format("%s-nap-%s", local.project_prefix, local.build_suffix)
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  version    = "2.0.1"
  namespace  = kubernetes_namespace.aws-nginx-ingress[0].metadata[0].name
  values     = [file("../charts/nginx-app-protect/values.yaml")]
  timeout    = 600

  depends_on = [
    kubernetes_secret.aws-docker-registry
  ]
}

resource "helm_release" "aws-prometheus" {
    count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
    provider = helm.aws
    name = format("%s-pro-%s", local.project_prefix, local.build_suffix)
    repository = "https://prometheus-community.github.io/helm-charts"
    chart = "prometheus"
    #version = "27.3.0"
    namespace = kubernetes_namespace.aws-monitoring[0].metadata[0].name
    values = [file("../charts/prometheus/values.yaml")]
}

resource "kubernetes_namespace" "aws-nginx-ingress" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
  provider = kubernetes.aws
  metadata {
    name = "nginx-ingress"
  }
}
resource "kubernetes_namespace" "aws-monitoring" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
  provider = kubernetes.aws
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_secret" "aws-nginx_license" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
  provider = kubernetes.aws
  metadata {
    name      = "license-token"
    namespace = kubernetes_namespace.aws-nginx-ingress[0].metadata[0].name
  }
  data = {
    "license.jwt" = var.nginx_jwt
  }
  type = "nginx.com/license"
}

resource "kubernetes_secret" "aws-docker-registry" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
  provider = kubernetes.aws
  metadata {
    name      = "regcred"
    namespace = kubernetes_namespace.aws-nginx-ingress[0].metadata[0].name
  }
  type = "kubernetes.io/dockerconfigjson"
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.nginx_registry}" = {
          "username" = var.nginx_jwt,  # Use the JWT token as the username
          "password" = "none",  # Set password to "none"
          "auth"     = base64encode("${var.nginx_jwt}:none")  # Encode "<jwt-token>:none"
        }
      }
    })
  }
}

resource "kubernetes_storage_class_v1" "aws_csi" {
  count    = var.CLOUD_PROVIDER == "AWS" ? 1 : 0
  provider = kubernetes.aws
  metadata {
    name = "ebs-sc"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Delete"
  parameters = {
    type = "gp3"
    fsType = "ext4"
  }
  allow_volume_expansion = true
  volume_binding_mode = "WaitForFirstConsumer"
}