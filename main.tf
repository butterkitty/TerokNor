// Configure the Google Cloud provider and Kubernetes provider
// I would very likely use a Cloud KMS with encryption to store this usually, instead of a plain json file.

// Given help, and more time I'd likely turn as much as I can that needs to be changed on this page to a variable

// List of regions and zones https://cloud.google.com/compute/docs/regions-zones
provider "google" {
    credentials = file("deployment_creds.json")
    project     = "deployment-test"
    region      = "northamerica-northeast1"
}
data "google_client_config" "provider" {}

data "google_container_cluster" "main-zone" {
    name     = "main-zone"
    location = "northamerica-northeast1-a" //Set this to the zone where the main pod is
}
provider "kubernetes" {
    host  = "https://${data.google_container_cluster.main-zone.endpoint}" //CHANGE THIS TO THE PROPER ZONE NAME
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
        data.google_container_cluster.main-zone.master_auth[0].cluster_ca_certificate, //CHANGE THIS TO THE PROPER ZONE NAME
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
variable "main_subdomain" {
    description = "This is the subdomain for apache2"
    type = string
}
variable "myadmin_subdomain" {
    description = "This is the subdomain for phpmyadmin"
    type = string
}
// Would use cert_manager, but no time
