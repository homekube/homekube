#!/bin/bash

if kubectl get ns | grep -q "^keycloak"; then
  echo "Skipping installation of keycloak because namespace already exists"
  echo "If you want to reinstall execute: "
  echo "'kubectl delete ns keycloak'"
  exit 1
else

echo "Install keycloak oauth service"

kubectl create ns keycloak

# create keycloak user and database - errors will be ignored if this step is repeated
# in case of trouble use the drop-keycloak.sql script
kubectl wait -n postgres --for=condition=Ready pod/postgres-0 --timeout=120s
envsubst < create-keycloak.sql | kubectl exec postgres-0 -i -n postgres -- psql -U admin -d postgres

# use a secret for passwords
kubectl create secret generic keycloak-secret -n keycloak \
--from-literal=KEYCLOAK_ADMIN_PASSWORD=${HOMEKUBE_KEYCLOAK_PASSWORD} \
--from-literal=KC_DB_PASSWORD=${HOMEKUBE_PG_PASSWORD}

# Installing ingress and keycloak
envsubst < ingress.yaml | kubectl apply -f -
envsubst < keycloak.yaml | kubectl apply -f -

echo "Installation done keycloak app"
fi # end if installation of whoami
