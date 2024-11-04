#!/bin/bash

if kubectl get ns | grep -q "^postgres"; then
  echo "Skipping installation of postgres because namespace already exists"
  echo "If you want to reinstall execute: "
  echo "'kubectl delete ns postgres'"
  echo "'kubectl delete pv postgres-pv'"
  exit 1
else

echo "Install postgres"

kubectl create namespace postgres

# use a secret for passwords
kubectl create secret generic postgres-secret -n postgres \
--from-literal=POSTGRES_PASSWORD=${HOMEKUBE_PG_PASSWORD}

envsubst < postgres-nfs.yaml | kubectl apply -f -

fi
