resource "kubernetes_deployment" "apache2_koho" {
  metadata {
    name = "apache2-koho"

    labels = {
      app  = "apache2-koho"
      role = "master"
      tier = "frontend"
    }
  }
  spec {
    replicas = 3
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge = 1
        max_unavailable = 1
      }      
    }
    selector {
      match_labels = {
        app  = "apache2-koho"
        role = "master"
        tier = "frontend"
      }
    }
    template {
      metadata {
        labels ={
          app  = "apache2-koho"
          role = "master"
          tier = "frontend"
        }
      }
      spec {
        container {
          image = "httpd:latest"
          name  = "apache2"
        
/*          port {
            container_port = 80
          }*/
          env {
              name = "PORT"
              value = "80"
          }
          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 2
            period_seconds = 10
          }
        }
      }
    }
  }
}