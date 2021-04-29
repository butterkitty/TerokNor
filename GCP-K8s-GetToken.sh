#!/bin/bash
# Usage: ./GCP-K8s-GetToken.sh <clustername> <zone>
gcloud container clusters get-credentials $1--region $2


kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')