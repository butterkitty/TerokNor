resource "kubernetes_ingress" "apache2_ingress" {
    metadata {
        name = "apache2-ingress"
        annotations = {
            "kubernetes.io/ingress.class" = "gce"
        }
    }    
    spec {
        rule {
            host = var.main_subdomain
            http {
                path {
                    path = "/*"
                    backend {
                        service_name = kubernetes_service.apache2.metadata.0.name
                        service_port = kubernetes_service.apache2.spec.0.port.0.port
                    }
                }
            }
        }
        tls {
            hosts = [var.main_subdomain]
            secret_name = kubernetes_secret.tls.metadata.0.name
        }
    }
}
resource "kubernetes_ingress" "myadminingress" {
    metadata {
        name = "myadmin-ingress"
        annotations = {
            "kubernetes.io/ingress.class" = "gce"
        }
    }    
    spec {
        rule {
            host = var.myadmin_subdomain
            http {
                path {
                    path = "/*"
                    backend {
                        service_name = kubernetes_service.phpmyadmin.metadata.0.name
                        service_port = kubernetes_service.phpmyadmin.spec.0.port.0.port
                    }
                }
            }
        }
        tls {
            hosts = [var.myadmin_subdomain]
            secret_name = kubernetes_secret.myadmin_tls.metadata.0.name
        }
    }
}