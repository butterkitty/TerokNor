#Ingress required in order to specify tls
resource "kubernetes_ingress" "http_ingress" {
  metadata {
      name = "http-ingress"
  }    
  spec {
      backend {
          service_name = kubernetes_deployment.apache2_koho.metadata.0.name
          service_port = "80"
      }
      tls {
          hosts = ["koho.rescuityonline.com"]
          secret_name = "koho_tls"
      }
  }
}


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