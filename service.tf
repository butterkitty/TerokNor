resource "kubernetes_service" "apache2" {
    metadata {
        name = "apache2"
    }
    spec {
        selector = {
            app = kubernetes_deployment.apache2-koho.metadata.0.name
        }
//        session_affinity = "ClientIP"
        type = "NodePort"
        port {
            name = "apache2"
            port = 8080
            target_port = 80
        }
    }
}
resource "kubernetes_service" "phpmyadmin" {
    metadata {
        name = "phpmyadmin"
    }
    spec {
        selector = {
            app = kubernetes_deployment.phpmyadmin.metadata.0.name
        }
//        session_affinity = "ClientIP"
        type = "NodePort"
        port {
            name = "phpmyadmin"
            port = 8080
            target_port = 80
        }
    }
}