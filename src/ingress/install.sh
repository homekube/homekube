#!/bin/bash

kubectl get ns ingress-nginx
if [[ $?  -eq 0 ]]; then
  echo "Skipping installation of nginx webserver because the namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns ingress-nginx' and run this script again"
else
echo "Install ingress web server"
kubectl create namespace ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install nginx-helm -n ingress-nginx --version=4.0.6 \
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
