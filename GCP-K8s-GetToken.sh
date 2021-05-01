#!/bin/bash
# Usage: ./GCP-K8s-GetToken.sh <clustername> <zone> <admin?(1|0)
gcloud container clusters get-credentials $1 --region $2

case $3 in
# Have to echo or else there will be a trailing percent symbol
    1)    echo $(kubectl -n kube-system get secret "$(kubectl -n kube-system get secret | grep admin-user-token | cut -d' ' -f1)" -o jsonpath='{.data.token}' | base64 --decode)
    ;;
    0)    echo $(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}'))
    ;;
esac
