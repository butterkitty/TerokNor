//Would use tls connect mariadb for apache app with more time
/*resource "helm_release" "mariadb-galera" {
    name       = "mariadb-galera"

    repository = "https://charts.bitnami.com/bitnami"
    chart      = "mariadb-galera"

    values = [
        file("mariadb-helm.yaml")
    ]
}*/