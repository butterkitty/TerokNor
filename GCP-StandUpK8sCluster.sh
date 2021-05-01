#!/bin/bash

# INSTRUCTIONS:

# Install the GCloud SDK https://cloud.google.com/sdk/docs/install
# Install kubectl 1.19.9 using the kubectl binary with curl method 
#   https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/ (Replace the current version in the url with v1.19.9)

# Install terraform 

# Setup a new service on Google
# Navigate to https://cloud.google.com/service-infrastructure/docs/service-management/getting-started
# Follow the directions on the page and when downloading the json file, download it to this folder and name it "deployment_creds.json"

# (Make sure to add the service account to the roles: Compute Engine default service account and Google APIs Service Agent)


# Generate the certificates using:
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#    -out tls.crt \
#    -keyout tls.key \
#    -subj "/CN=<subdomain>/O=koho-tls"
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#    -out myadmintls.crt \
#    -keyout myadmintls.key \
#    -subj "/CN=<subdomain>/O=koho-tls"
# 
# CHANGE <subdomain> TO YOUR OWN AND USE 2 DIFFERENT SUBDOMAINS

# Change all the settings to your own in the main.tf file and the gcloud commands in this file.

project="koho-deployment-test"
cluster_name="main-zone"
cluster_version="1.19.9-gke.1400"
network_region="northamerica-northeast1"
main_node_zone="northamerica-northeast1-a"
node_locations="northamerica-northeast1-a,northamerica-northeast1-b,northamerica-northeast1-c"
#Number of nodes PER ZONE
num_nodes=1


# BEGIN!
# Choosing K8s v1.19.9 since that is what I am running for my cluster at home and it's in the sweet spot of new/old.
# Keeping hdd's on nodes smaller @ 40GB since we're not running much, but I don't want to be bound up in the future in case we want to install more applications.
# Turning off many settings because I am legit deploying this to my own GCP, and I don't want to pay too much.  I still want the load-balancer though since that will make future configuration for ingress easier.
# Node machine size is micro and wouldn't run production services on this size, BUT I'm paying for this, so this is how it'll be for the test.
# CSI Driver for automatic provisioning of persistent storage since I am standing up a database.
# Using the cidr 10.96.0.0/19 for networking since it's close to vanilla K8s and it still offers 8192 IP's
# (Due to time constraints, and really ease of use since Google gives you the bash line required based on settings chosen, I am using bash and gcloud to provision the cluster, and NOT using a multi-master setup as would be necessary for proper SRE practices)
gcloud beta container --project $project clusters create $cluster_name --zone $main_node_zone --no-enable-basic-auth --cluster-version $cluster_version --release-channel "None" --machine-type "e2-micro" --image-type "COS_CONTAINERD" --disk-type "pd-standard" --disk-size "40" --node-labels test-node=True --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes $num_nodes --no-enable-stackdriver-kubernetes --enable-ip-alias --network "projects/koho-deployment-test/global/networks/default" --subnetwork "projects/koho-deployment-test/regions/$network_region/subnetworks/default" --cluster-ipv4-cidr "10.96.0.0/19" --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --no-enable-autoupgrade --no-enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --node-locations $node_locations

# Gather the credentials for kubectl so we can do work with it
gcloud container clusters get-credentials main-zone --region $main_node_zone

# Deploy the K8s Dashboard
echo "Deploying the Kubernetes Dashboard"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
kubectl apply -f https://raw.githubusercontent.com/hashicorp/learn-terraform-provision-gke-cluster/master/kubernetes-dashboard-admin.rbac.yaml
echo "Initializing Terraform"
terraform init
echo "Applying Terraform templates"
terraform apply

echo -e "\n \n \n \n \n"

printf "Welcome to "
sleep 1
for i in {1..3}
do
printf "."
sleep 1
done
echo -e "\n"
cat << EOF
 ▄▄▄▄▄▄▄▄                                ▄▄        ▄▄▄   ▄▄                     
 ▀▀▀██▀▀▀                                ██        ███   ██                     
    ██      ▄████▄    ██▄████   ▄████▄   ██ ▄██▀   ██▀█  ██   ▄████▄    ██▄████ 
    ██     ██▄▄▄▄██   ██▀      ██▀  ▀██  ██▄██     ██ ██ ██  ██▀  ▀██   ██▀     
    ██     ██▀▀▀▀▀▀   ██       ██    ██  ██▀██▄    ██  █▄██  ██    ██   ██      
    ██     ▀██▄▄▄▄█   ██       ▀██▄▄██▀  ██  ▀█▄   ██   ███  ▀██▄▄██▀   ██      
    ▀▀       ▀▀▀▀▀    ▀▀         ▀▀▀▀    ▀▀   ▀▀▀  ▀▀   ▀▀▀    ▀▀▀▀     ▀▀      
EOF
sleep 3
echo "I hope you will enjoy your stay!"
sleep 3
mariadbpass=$(kubectl get secret --namespace default mariadb-galera -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
echo "Your mariadb root password is: " $mariadbpass
mariadbpass=""
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')
echo -e "\nAccess http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/ and use the token printed previously to continue\n"
echo -e "\nREMEMBER: It can take up to 10 minutes for everything to stabilize and for Google to properly create the load balancers in GCP\n"

echo "NOTE: THE TOKEN PROVIDED IS NOT THE ADMIN USER. TO GET THAT, RUN: ./GCP-K8s-GetToken.sh $cluster_name $main_node_zone 1"

kubectl proxy

# Navigate to the dashboard, look at the ingresses and, eventually depending on how slow Google is being, there should be an ip per ingress.  
# These are the load balencers and should be set accordingly to the dns' that we set during the setup process

# To test connectivity, log in phpmyadmin as root on the myadmin subdomain using the mariadb root password given
# Notice that it has access to the DB and lists all the information for the Galera cluster.