# # Read infra state from S3
# data "terraform_remote_state" "infra" {
#   backend = "s3"
#   config = {
#     bucket =  var.AWS_S3_BUCKET_NAME       # Your S3 bucket name
#     key    = "infra/terraform.tfstate"       # Path to infra's state file
#     region = var.AWS_REGION                    # AWS region
#   }
# }
#
#
# data "terraform_remote_state" "nap" {
#   backend = "s3"
#   config = {
#     bucket =  var.AWS_S3_BUCKET_NAME       # Your S3 bucket name
#     key    = "nap/terraform.tfstate"         # Path to NAP state file
#     region = var.AWS_REGION                    # AWS region
#   }
# }
#
# data "terraform_remote_state" "eks" {
#   backend = "s3"
#   config = {
#     bucket =  var.AWS_S3_BUCKET_NAME       # Your S3 bucket name
#     key    = "eks-cluster/terraform.tfstate"  # Path to EKS state file
#     region = var.AWS_REGION                     # AWS region
#   }
# }
#
# # Get EKS cluster auth using S3 state
# data "aws_eks_cluster_auth" "auth" {
#   name = data.terraform_remote_state.eks.outputs.cluster_name
# }

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
    key    = "cluster/terraform.tfstate" # Path to EKS state file
    region = var.AWS_REGION                    # AWS region
  }
}

# Read nap state from S3
data "terraform_remote_state" "aws-nap" {
  count = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is AWS
  backend = "s3"
  config = {
    bucket =  var.AWS_S3_BUCKET_NAME        # Your S3 bucket name
    key    = "nap/terraform.tfstate"         # Path to NAP state file
    region = var.AWS_REGION                       # AWS region
  }
}

data "aws_eks_cluster_auth" "auth" {
  count = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is AWS
  provider = aws.aws
  name = data.terraform_remote_state.eks[0].outputs.cluster_name
}

data "terraform_remote_state" "gcp-infra" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  backend = "gcs"
  config = {
    bucket = var.GCP_BUCKET_NAME       # Your S3 bucket name
    prefix    = "infra/terraform.tfstate"       # Path to infra's state file
  }
}

# Read eks state from gcs
data "terraform_remote_state" "gke" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  backend = "gcs"
  config = {
    bucket =  var.GCP_BUCKET_NAME        # Your S3 bucket name
    prefix    = "cluster/terraform.tfstate" # Path to EKS state file
  }
}

# Read nap state from gcs
data "terraform_remote_state" "gcp-nap" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  backend = "gcs"
  config = {
    bucket =  var.GCP_BUCKET_NAME        # Your S3 bucket name
    prefix    = "nap/terraform.tfstate" # Path to EKS state file
  }
}