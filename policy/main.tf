provider "aws" {
    region = local.aws_region
    alias = "aws"
}

provider "google" {
    region = local.region
    alias = "gcp"
}
