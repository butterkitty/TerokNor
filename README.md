# devops-takehome-michelleplarina
![image](https://user-images.githubusercontent.com/481603/116768233-03c81480-aa03-11eb-896b-0b3ac0223ef8.png)

A repo set up for the employment test with Koho

# Requirements:

* Bash
* OpenSSL to generate certificates (If you already have certificates, you can omit this requirement)
* Install the GCloud SDK https://cloud.google.com/sdk/docs/install
* Install kubectl 1.19.9 using the kubectl binary with curl method https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/ (Replace the current version in the url with v1.19.9) *NOTE: You can install kubectl via apt-get or similar, if that is your preference, and if you can get this particular version*

* Install terraform https://learn.hashicorp.com/tutorials/terraform/install-cli


# Instructions:

Most of the instructions are also in the file GCP-StandUpK8sCluster.sh, which is the main file that will also setup, via Bash, the whole cluster, provision the needed servers, and setup the proxy for the Kubernetes dashboard.

Setup a new service on Google
Navigate to https://cloud.google.com/service-infrastructure/docs/service-management/getting-started

**Make sure that you are the owner of the project for the account you used to login to when signed into Google Cloud**

Follow the directions on the page and when downloading the json file, download it to this folder and name it "deployment_creds.json"

**(Make sure to add the service account to the roles: Kubernetes Engine Admin, Storage Admin, and Viewer (Seriously, the role called Viewer).  These can be added via the IAM section in the Google Cloud Console for the service account you created)**


## Generate the certificates using:
*NOTE: If you already have the certificates for each domain, just name them appropriately*

`openssl req -x509 -nodes -days 365 -newkey rsa:2048
   -out tls.crt
   -keyout tls.key
   -subj "/CN=<FQDN>/O=yourorganization"`

`openssl req -x509 -nodes -days 365 -newkey rsa:2048
   -out myadmin-tls.crt
   -keyout myadmin-tls.key
   -subj "/CN=<FQDN>/O=yourorganization"`

**Change `<FQDN>` to your own and use 2 different FQDN's**

Next change all the settings to your own in the main.tf file and the gcloud commands in this file appropriately to your given plan. For the project, use the project ID, not the name. This can be seen via when you choose which project to use in the GCloud Console.

Take the following steps to enable the Kubernetes Engine API:
  1. Visit the Kubernetes Engine page in the Google Cloud Console.
  2. Create or select a project.
  3. Wait for the API and related services to be enabled. This can take several minutes.

[Enable Billing on your project](https://cloud.google.com/billing/docs/how-to/modify-project)


Run `./GCP-StandUpK8sCluster.sh` and let Terok Nor fly!

After the script finishes running, heed the instructions printed out to the terminal by the script

# Verification

Navigate to the dashboard, look at the ingresses and, eventually depending on how slow Google is being, there should be an ip per ingress.  

These are the load balencers and should be set accordingly to the DNS' that we set during the setup process

Navigate to the apache2 dns to test the apache2 server and the myadmin DNS to test phpmyadmin


## To test connectivity:
Log in phpmyadmin as root on the myadmin subdomain using the mariadb root password given during setup

Notice that it has access to the DB and lists all the information for the Galera cluster.


# Cleanup
Delete the cluster from the [Google Cloud Console - Kubernetes Engine](https://console.cloud.google.com/kubernetes/)

Delete the load balancers from [Google Cloud Console - Network Services - Load Balancing](https://console.cloud.google.com/net-services/loadbalancing/)

Delete the project (if you created it just for this)

# Explanation of Tradeoffs Made Due to Timeboxing
* I would have used a certificate manager inside kubernetes to manage the certificate secrets.  This would have the bonus of making it more secure as well as easier on the user. (DON'T USE WILDCARD CERTS IN PROD!)
* Have the system automatically update the DNS using Google Cloud DNS (I've done this before and have a script for this in my [Helper-Scripts](https://github.com/butterkitty/Helper-Scripts) repository)
* I would likely store the Google Sevice Account credentials json using a KMS of some sort
* Deploy a multiple master setup across multiple regions
* Likely move the bash script into Terraform and output the given information from Terraform
* Turn more of what is in the main.tf template into variables that the client can set
* Do more prechecks on permissions for Google to make sure everything is set up right
* Do more testing on the documentation (I rubber ducked it with someone for validation, but more is better)
* Better security for the DB, especially TLS login and defining the password from a keystore

