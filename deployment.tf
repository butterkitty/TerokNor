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
    replicas = 2
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
        
          port {
            container_port = 80
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
//Would tls connect mariadb for apache app
resource "kubernetes_deployment" "mariadb" {
  metadata {
    name = "mariadb"

    labels = {
      app  = "mariadb"
      role = "master"
      tier = "backend"
    }
  }
  spec {
    replicas = 2
      strategy {
       type = "RollingUpdate"
        rolling_update {
          max_surge = 1
          max_unavailable = 1
        }
      }
    selector {
      match_labels = {
        app  = "mariadb"
        role = "master"
        tier = "backend"
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
          image = "mariadb:10.3"
          name  = "mariadb"
          resources {
            requests = {
              storage = "5gi"
            }
          }
          port {
            container_port = 3306
          }
          volume_mount {
              mount_path = "/var/lib/mysql"
              name = "mariadb-data"
          }
        }
        //persistent_volume_claim {
        //  claim_name = "mariadb-data"
        //   = "mariadb-pvc"
        //}
      }
    }
  }
}

