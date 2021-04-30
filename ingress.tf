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
/*resource "google_compute_ssl_certificate" "https-koho-rescuityonline" {
  name_prefix = "koho-rescuityonline"
  description = "The tls cert for koho.rescuityonline.com"
  private_key = file("tls.key")
  certificate = file("tls.crt")

  lifecycle {
    create_before_destroy = true
  }
}*/

/*resource "kubernetes_ingress" "https_ingress" {
  metadata {
      name = "https-ingress"
  }    
  spec {
      backend {
          serviceName = "webserver"
          servicePort = "443"
      }
  }
}
*/