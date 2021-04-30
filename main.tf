// Configure the Google Cloud provider and Kubernetes provider
// I would very likely use a Cloud KMS with encryption to store this usually, instead of a plain json file.
provider "google" {
 credentials = file("koho-deployment-test_creds.json")
 project     = "koho-deployment-test"
 region      = "northamerica-northeast1"
}
data "google_client_config" "provider" {}

data "google_container_cluster" "main-cluster-zone-a" {
  name     = "main-cluster-zone-a"
  location = "northamerica-northeast1-b"
}
provider "kubernetes" {
  host  = "https://${data.google_container_cluster.main-cluster-zone-a.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.main-cluster-zone-a.master_auth[0].cluster_ca_certificate,
  )
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
variable "mariadb_pass" {
    description = "Database root password"
    type = string
    sensitive = true
}
// Would use cert_manager, but no time