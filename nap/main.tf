# provider "aws" {
#   region = local.aws_region
# }

# provider "kubernetes" {
#   host                   = data.terraform_remote_state.eks[0].outputs.cluster_endpoint
#   cluster_ca_certificate = base64decode(data.terraform_remote_state.eks[0].outputs.kubeconfig-certificate-authority-data)
#   token                  = data.aws_eks_cluster_auth.auth[0].token
#   alias                  = "aws"
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     args = [
#       "eks",
#       "get-token",
#       "--cluster-name",
#       data.terraform_remote_state.eks[0].outputs.cluster_name
#     ]
#   }
# }
#
# provider "helm" {
#   alias                  = "aws"
#   kubernetes {
#     host                   = data.terraform_remote_state.eks[0].outputs.cluster_endpoint
#     cluster_ca_certificate = base64decode(data.terraform_remote_state.eks[0].outputs.kubeconfig-certificate-authority-data)
#     token                  = data.aws_eks_cluster_auth.auth[0].token
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       command     = "aws"
#       args = [
#         "eks",
#         "get-token",
#         "--cluster-name",
#         data.terraform_remote_state.eks[0].outputs.cluster_name
#       ]
#     }
#   }
# }
#
# provider "kubectl" {
#   host                   = data.terraform_remote_state.eks[0].outputs.cluster_endpoint
#   cluster_ca_certificate = base64decode(data.terraform_remote_state.eks[0].outputs.kubeconfig-certificate-authority-data)
#   token                  = data.aws_eks_cluster_auth.auth[0].token
#   load_config_file       = false
#   alias                  = "aws"
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     args = [
#       "eks",
#       "get-token",
#       "--cluster-name",
#       data.terraform_remote_state.eks[0].outputs.cluster_name
#     ]
#   }
# }

# provider "google" {
#     region                  = local.region
# }

provider "kubernetes" {
  host                   = local.host
  cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
  token                  = local.cluster_token
  alias                  = "gcp"
  # Optional: Using exec for kubectl authentication
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gcloud"
    args = [
      "container", "clusters", "get-credentials",
      local.cluster_name,  # Assuming 'local.cluster_name' is set
      "--region", local.region  # Assuming 'local.cluster_region' is set
    ]
  }
}

provider "helm" {
  alias                  = "gcp"
  kubernetes {
    host                   = local.host
    cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
    token                  = local.cluster_token

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "gcloud"
      args = [
        "container", "clusters", "get-credentials",
        local.cluster_name,  # Cluster name
        "--region", local.region  # Cluster region
      ]
    }
  }
}

provider "kubectl" {
    host                    = local.host
    cluster_ca_certificate  = base64decode(local.cluster_ca_certificate)
    token                   = local.cluster_token
    load_config_file        = false
    alias                  = "gcp"
    exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gcloud"
    args = [
      "container", "clusters", "get-credentials",
      local.cluster_name,  # Cluster name
      "--region", local.region  # Cluster region
    ]
  }
}