# We don't need a storageclass since google automatically creates one by default which uses ext4
/*resource "kubernetes_persistent_volume_claim" "mariadb_pvc"{
    metadata {
        name = "mariadb-pvc"
    }
    spec {
        access_modes = ["ReadWriteOnce"]
    
        resources {
            requests {
                storage = "5Gi"
            }
        }
        volume_name = "${kubernetes_persistent_volume.example.metadata.0.name}"
    }
}*/