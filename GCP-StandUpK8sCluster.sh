#!/bin/bash

# Choosing K8s v1.19.9 since that is what I am running for my cluster at home.
# Keeping hdd's on nodes smaller @ 40GB since we're not running much, but I don't want to be bound up in the future in case we want to install more applications.
# Turning off many settings because I am legit deploying this to my own GCP, and I don't want to pay too much.  I still want the load-balancer though since that will make future configuration for ingress easier.
# Node machine size is micro and wouldn't run production services on this size, BUT I'm paying for this, so this is how it'll be for the test.
# CSI Driver for automatic provisioning of persistent storage since I am standing up a database.
# Using the cidr 10.96.0.0/19 for networking since it's close to vanilla K8s and it still offers 8192 IP's
# (Due to time constraints I am using bash and gcloud to provision the cluster, and NOT using a multi-master setup as would be necessary for proper SRE practices)
gcloud beta container --project "koho-deployment-test" clusters create "main-cluster-zone-a" --zone "northamerica-northeast1-b" --no-enable-basic-auth --cluster-version "1.19.9-gke.1400" --release-channel "None" --machine-type "e2-micro" --image-type "COS_CONTAINERD" --disk-type "pd-standard" --disk-size "40" --node-labels test-node=True --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --no-enable-stackdriver-kubernetes --enable-ip-alias --network "projects/koho-deployment-test/global/networks/default" --subnetwork "projects/koho-deployment-test/regions/northamerica-northeast1/subnetworks/default" --cluster-ipv4-cidr "10.96.0.0/19" --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --no-enable-autoupgrade --no-enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --node-locations "northamerica-northeast1-b, us-central1-a, us-east1-b"
#gcloud beta container --project "koho-deployment-test" clusters create "main-cluster-zone-b" --zone "us-east1-b" --no-enable-basic-auth --cluster-version "1.19.9-gke.1400" --release-channel "None" --machine-type "e2-micro" --image-type "COS_CONTAINERD" --disk-type "pd-standard" --disk-size "40" --node-labels test-node=True --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --no-enable-stackdriver-kubernetes --enable-ip-alias --network "projects/koho-deployment-test/global/networks/default" --subnetwork "projects/koho-deployment-test/regions/northamerica-northeast1/subnetworks/default" --cluster-ipv4-cidr "10.96.0.0/19" --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --no-enable-autoupgrade --no-enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --node-locations "northamerica-northeast1-b, us-central1-a, us-east1-b"

# Gather the credentials for kubectl so we can do work with it
gcloud container clusters get-credentials main-cluster-zone-a --region northamerica-northeast1-b

# Deploy the K8s Dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
kubectl apply -f https://raw.githubusercontent.com/hashicorp/learn-terraform-provision-gke-cluster/master/kubernetes-dashboard-admin.rbac.yaml
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')
echo "\nAccess http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/ and use the token printed previously to continue\n"
kubectl proxy

# Gather the credentials for kubectl so we can do work with it
#gcloud container clusters get-credentials main-cluster-zone-b --region us-east1-b

# Deploy the K8s Dashboard
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
#kubectl apply -f https://raw.githubusercontent.com/hashicorp/learn-terraform-provision-gke-cluster/master/kubernetes-dashboard-admin.rbac.yaml
#kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')
#echo "\nAccess http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/ and use the token printed previously to continue\n"
#kubectl proxy

#Setup dns
# Config DNS in ingress, 
# Change email in setupCerts.yaml