resource "kubernetes_service" "main" {
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
resource "kubernetes_service" "backend" {
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
resource "kubernetes_service" "app_2" {
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
resource "kubernetes_service" "app_3" {
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