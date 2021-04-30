// I would likely store this file in a vault like keypass or the Google Cloud Secrets Engine
// Also, I would very likely just use cert_manager
resource "kubernetes_secret" "koho_tls" {
  metadata {
    name = "koho-tls"
  }

  data = {
    "tls.crt" = file("tls.crt")
    "tls.key" = file("tls.key")
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

    // Need to have this dependency or else phpmyadmin will try to install before the db is even created
    //depends_on = [helm_release.mariadb-galera]
}
