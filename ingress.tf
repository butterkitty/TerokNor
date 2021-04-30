#Ingress required in order to specify tls
resource "kubernetes_ingress" "apache2_ingress" {
  metadata {
      name = "apache2-ingress"
      annotations = {
          "kubernetes.io/ingress.class" = "gce"
      }
  }    
  spec {
      rule {
        http {
            path {
                path = "/*"
                backend {
                    service_name = kubernetes_service.koho-rescuityonline.metadata.0.name
                    service_port = "8080"
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