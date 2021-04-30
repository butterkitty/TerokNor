resource "kubernetes_service" "koho-rescuityonline" {
    metadata {
        name = "apache2"
    }
    spec {
        selector = {
            app = kubernetes_deployment.apache2_koho.metadata.0.name
        }
        session_affinity = "ClientIP"
        type = "NodePort"
        port {
            name = "http"
            port = 8080
            target_port = 80
        }
    }
}