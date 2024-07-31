#!/bin/bash

kubectl get ns keycloak
if [[ $?  -eq 0 ]]; then
  echo "Skipping installation of keycloak because namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns keycloak'"
else
echo "Install keycloak oauth service"

kubectl create ns keycloak

envsubst < ingress.yaml | kubectl apply -f -
envsubst < keycloak.yaml | kubectl apply -f -
