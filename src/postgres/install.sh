#!/bin/bash

kubectl get ns postgres
if [[ $?  -eq 0 ]]; then
  echo "Skipping installation of postgres because namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns postgres'"
else
echo "Install postgres"

kubectl create namespace postgres

# use a secret for passwords
kubectl create secret generic psql-secret -n postgres \
--from-literal=POSTGRES_PASSWORD=${HOMEKUBE_PG_PASSWORD}

envsubst < postgres-nfs.yaml | kubectl apply -f -

fi
