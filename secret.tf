// I would likely store this file in a vault like keypass or the Google Cloud Secrets Engine
// Also, I would very likely just use cert_manager
resource "kubernetes_secret" "koho_tls" {
  metadata {
    name = "koho_tls"
  }

  data = {
    "tls.crt" = file("tls.crt")
    "tls.key" = file("tls.key")
  }

  type = "kubernetes.io/basic-auth"
}