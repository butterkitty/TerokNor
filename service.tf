resource "kubernetes_service" "koho.rescuityonline.com" {
  metadata {
    name = kubernetes_deployment.apache2_koho.metadata.0.labels.app
  }
  spec {
    selector = {
      app = "apache2-koho"
    }
    session_affinity = "ClientIP"
    type = "LoadBalancer"
    port {
      port = 80
      target_port = 80
    }
  }
}