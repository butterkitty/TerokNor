resource "kubernetes_persistent_volume_claim" "mariadb_pvc"{
  metadata {
    name = "mariadb-pvc"
  }
  spec {
    accessModes = ["ReadWriteMany"]
    
    resources {
      requests {
        storage = "5Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.example.metadata.0.name}"
  }
}