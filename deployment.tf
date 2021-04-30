resource "kubernetes_deployment" "apache2-koho" {
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
resource "kubernetes_deployment" "phpmyadmin" {
  metadata {
    name = "phpmyadmin"

    labels = {
      app  = "phpmyadmin"
      role = "master"
      tier = "frontend"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app  = "phpmyadmin"
        role = "master"
        tier = "frontend"
      }
    }
    template {
      metadata {
        labels ={
          app  = "phpmyadmin"
          role = "master"
          tier = "frontend"
        }
      }
      spec {
        container {
          name = "phpmyadmin"
          image  = "phpmyadmin/phpmyadmin"
        
          port {
              container_port = 80
          }
          env {
              name = "PMA_HOST"
              value = "mariadb-galera"
          }
          env {
              name = "PMA_PORT"
              value = "3306"
          }
          env {
              name = "PMA_ABSOLUTE_URI"
              value = "https://koho.rescuityonline.com/phpmyadmin"
          }
          env {
              name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref { 
                  name = "mariadb-phpmyadmin"
                  key = "MYSQL_ROOT_PASSWORD"
              }
            }
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