// I would likely store this file in a vault like keypass or the Google Cloud Secrets Engine
// Also, I would very likely just use cert_manager
resource "kubernetes_secret" "tls" {
  metadata {
    name = "koho-tls"
  }

  data = {
    "tls.crt" = file("tls.crt")
    "tls.key" = file("tls.key")
  }

  type = "kubernetes.io/tls"
}
resource "kubernetes_secret" "myadmin_tls" {
  metadata {
    name = "kohomyadmin-tls"
  }

  data = {
    "tls.crt" = file("myadmin-tls.crt")
    "tls.key" = file("myadmin-tls.key")
  }

  type = "kubernetes.io/tls"
}
resource "kubernetes_secret" "mariadb-phpmyadmin" {
    metadata {
        name = "mariadb-phpmyadmin"
    }
    data = {
        MYSQL_ROOT_PASSWORD = var.mariadb_pass    
    }
    type = "kubernetes.io/opaque"
}
