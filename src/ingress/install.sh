#!/bin/bash

if kubectl get ns | grep -q "^ingress-nginx"; then
  echo "Skipping installation of ingress-nginx because namespace already exists"
  echo "If you want to reinstall execute: "
  echo "'kubectl delete ns ingress-nginx'"
else

if ! helm repo list | grep -q "^ingress-nginx"; then
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo update ingress-nginx
fi

echo "Install ingress web server"

kubectl create namespace ingress-nginx
helm install nginx-helm -n ingress-nginx --version=4.10.1 \
    -f - ingress-nginx/ingress-nginx << EOF
controller:
  metrics:
    enabled: true
    service:
      # important for detection of nginx datasource by prometheus
      annotations: {
        prometheus.io/scrape: "true" ,
      }
EOF
echo "Installation done ingress"
fi # end of installation of nginx webservice
