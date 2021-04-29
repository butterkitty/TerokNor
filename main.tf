// Configure the Google Cloud provider
// I would very likely use a Cloud KMS with encryption to store this usually, instead of a plain json file.
provider "google" {
 credentials = file("koho-deployment-test_creds.json")
 project     = "koho-deployment-test"
 region      = "northamerica-northeast1"
}