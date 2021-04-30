//Would tls connect mariadb for apache app
resource "helm_release" "mariadb-galera" {
    name       = "mariadb-galera"

    repository = "https://charts.bitnami.com/bitnami"
    chart      = "mariadb-galera"

    values = [
        file("mariadb-helm.yaml")
    ]
}
/*  metadata {
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
              storage = "5Gi"
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
        persistent_volume_claim {
          claim_name = "mariadb-data"
           = "mariadb-pvc"
        }
      }
    }
  }
}*/