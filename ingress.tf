resource "kubernetes_ingress" "apache2_ingress" {
    metadata {
        name = "apache2-ingress"
        annotations = {
            "kubernetes.io/ingress.class" = "gce"
        }
    }    
    spec {
        rule {
            host = "koho.rescuityonline.com"
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
            hosts = ["koho.rescuityonline.com"]
            secret_name = "koho-tls"
        }
    }
}
resource "kubernetes_ingress" "kohomyadminingress" {
    metadata {
        name = "kohomyadmin-ingress"
        annotations = {
            "kubernetes.io/ingress.class" = "gce"
        }
    }    
    spec {
        rule {
            host = "kohomyadmin.rescuityonline.com"
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
            hosts = ["kohomyadmin.rescuityonline.com"]
            secret_name = "kohomyadmin-tls"
        }
    }
}