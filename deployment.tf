resource "kubernetes_deployment" "apache2_koho" {
  metadata {
    name = "apache2-koho"

    labels {
      app  = "apache2-koho"
      role = "master"
      tier = "frontend"
    }
  }
  spec {
    replicas = 2

    selector {
      app  = "apache2-koho"
      role = "master"
      tier = "frontend"
    }
    strategy {
      rollingUpdate {
        maxSurge = 1
        maxUnavailable = 1
      }
      type = "RollingUpdate"
    }

    template {
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
          initialDelaySeconds = 2
          periodSeconds = 10
        }
      }
    }
  }
}
resource "kubernetes_deployment" "mariadb_deployment" {
  metadata {
    name = "mariadb"

    labels {
      app  = "mariadb"
      role = "master"
      tier = "backend"
    }
  }
  spec {
    replicas = 2

    selector {
      app  = "mariadb"
      role = "master"
      tier = "backend"
    }
    strategy {
      rollingUpdate {
        maxSurge = 1
        maxUnavailable = 1
      }
      type = "RollingUpdate"
    }

    template {
      container {
        image = "mariadb:10.3"
        name  = "mariadb"
        
        port {
          container_port = 3306
        }
        volumeMounts {
            mountPath = "/var/lib/mysql"
            name = "mariadb-data"
        }
      }
      volumes {
        name = "mariadb-data"
        persistentVolumeClaim = "mariadb-pvc"
      }
    }
  }
}

