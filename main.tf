// Configure the Google Cloud provider and Kubernetes provider
// I would very likely use a Cloud KMS with encryption to store this usually, instead of a plain json file.
provider "google" {
 credentials = file("koho-deployment-test_creds.json")
 project     = "koho-deployment-test"
 region      = "northamerica-northeast1"
}
data "google_client_config" "provider" {}

data "google_container_cluster" "cluster-zone-a" {
  name     = "main-cluster-zone-a"
  location = "northamerica-northeast1"
}
provider "kubernetes" {
  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
}
module "cert_manager" {
  source = "github.com/sculley/terraform-kubernetes-cert-manager"

  replica_count = 2
}