resource "kubernetes_service" "apache2" {
    metadata {
        name = "apache2"
    }
    spec {
        selector = {
            app = "apache2-koho"
        }
        session_affinity = "ClientIP"
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
            app = "phpmyadmin"
        }
        type = "NodePort"
        port {
            name = "phpmyadmin"
            port = 8080
            target_port = 80
        }
    }
}