#!/bin/bash

kubectl get ns postgres
if [[ $?  -eq 0 ]]; then
  echo "Skipping installation of postgres because namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns postgres'"
else
echo "Install postgres"

kubectl create namespace postgres
envsubst < postgres-nfs.yaml | kubectl apply -f -

fi
