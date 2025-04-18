resource "kubernetes_service" "aws-main" {
  count = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is AWS
  provider = kubernetes.aws
  metadata {
    name = "main"
    labels = {
      app = "main"
      service = "main"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }
    selector = {
      app = "main"
    }
    type = "ClusterIP"
  }
}
resource "kubernetes_service" "aws-backend" {
  count = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is AWS
  provider = kubernetes.aws
  metadata {
    name = "backend"
    labels = {
      app = "backend"
      service = "backend"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }
    selector = {
      app = "backend"
    }
    type = "ClusterIP"
  }
}
resource "kubernetes_service" "aws-app_2" {
  count = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is AWS
  provider = kubernetes.aws
  metadata {
    name = "app2"
    labels = {
      app = "app2"
      service = "app2"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }
    selector = {
      app = "app2"
    }
    type = "ClusterIP"
  }
}
resource "kubernetes_service" "aws-app_3" {
  count = var.CLOUD_PROVIDER == "AWS" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is AWS
  provider = kubernetes.aws
  metadata {
    name = "app3"
    labels = {
      app = "app3"
      service = "app3"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }
    selector = {
      app = "app3"
    }
    type = "ClusterIP"
  }
}

######################################################
####################### GCP ##########################
######################################################

resource "kubernetes_service" "gcp-main" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  provider = kubernetes.gcp
  metadata {
    name = "main"
    labels = {
      app = "main"
      service = "main"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }
    selector = {
      app = "main"
    }
    type = "ClusterIP"
  }
}
resource "kubernetes_service" "gcp-backend" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  provider = kubernetes.gcp
  metadata {
    name = "backend"
    labels = {
      app = "backend"
      service = "backend"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }
    selector = {
      app = "backend"
    }
    type = "ClusterIP"
  }
}
resource "kubernetes_service" "gcp-app_2" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  provider = kubernetes.gcp
  metadata {
    name = "app2"
    labels = {
      app = "app2"
      service = "app2"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }
    selector = {
      app = "app2"
    }
    type = "ClusterIP"
  }
}
resource "kubernetes_service" "gcp-app_3" {
  count = var.CLOUD_PROVIDER == "GCP" ? 1 : 0  # Only create this block if CLOUD_PROVIDER is GCP
  provider = kubernetes.gcp
  metadata {
    name = "app3"
    labels = {
      app = "app3"
      service = "app3"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }
    selector = {
      app = "app3"
    }
    type = "ClusterIP"
  }
}