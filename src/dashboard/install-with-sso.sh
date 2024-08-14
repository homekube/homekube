#!/bin/bash

kubectl get ns kubernetes-dashboard
if [[ $?  -eq 0 ]]; then
  echo "Skipping installation of dashboard because namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns kubernetes-dashboard'"
else
echo "Install kubernetes dashboard"
# Add kubernetes-dashboard repository
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
# Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard --version 7.5.0

envsubst < oauth2/create-group-bindings.yaml | kubectl apply -f -
envsubst < oauth2/ingress-sso.yaml | kubectl apply -f -
envsubst < oauth2/oauth2.yaml | kubectl apply -f -

echo "Installation done dashboard"
fi # end of installation of kubernetes dashboard
