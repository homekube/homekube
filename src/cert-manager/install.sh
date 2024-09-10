#!/bin/bash

if [[ ! -f acme-dns-${HOMEKUBE_DOMAIN_DASHED}.json ]]; then
    echo "File 'acme-dns-${HOMEKUBE_DOMAIN_DASHED}.json' does not exist - read and check that all preconditions are met ../docs/cert-manager.md"
    exit 2
fi

if kubectl get ns | grep -q "^cert-manager$"; then
  echo "Skipping installation of cert-manager because namespace already exists"
  echo "If you want to reinstall execute: "
  echo "'kubectl delete ns cert-manager'"
  exit 1
else

echo "Install cert-manager (Automating LetsEncrypt DNS01 wildcard certificates)"

# Creates ns cert-manager
kubectl create -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.1/cert-manager.yaml

kubectl create ns cert-manager-${HOMEKUBE_DOMAIN_DASHED}
kubectl create secret generic acme-dns-secret -n cert-manager-${HOMEKUBE_DOMAIN_DASHED} --from-file=acme-dns-secret-key=acme-dns-${HOMEKUBE_DOMAIN_DASHED}.json

# Verify the setup by creating a staging (test) secret
envsubst < staging-template.yaml | kubectl apply -f -
echo "Waiting for the staging secret from LetsEncypt up to 120s - be patient"
kubectl wait --for=condition=Exists -n cert-manager-${HOMEKUBE_DOMAIN_DASHED} --timeout=120s secrets/tls-staging
if [[ $? -ne 0 ]]; then
    echo "Could not obtain a staging secret - read and check that all preconditions are met ../docs/cert-manager.md"
    exit 3
fi
kubectl describe secret tls-staging -n cert-manager-${HOMEKUBE_DOMAIN_DASHED}

# Obtain the production secret from LetsEncrypt
envsubst < prod-template.yaml | kubectl apply -f -
echo "Waiting for the production /real) from LetsEcypt secret up to 120s - be patient"
kubectl wait --for=condition=Exists -n cert-manager-${HOMEKUBE_DOMAIN_DASHED} --timeout=120s secrets/tls-prod
if [[ $? -ne 0 ]]; then
    echo "Could not obtain a production secret - read and check that all preconditions are met ../docs/cert-manager.md"
    exit 3
fi
kubectl describe secret tls-prod -n cert-manager-${HOMEKUBE_DOMAIN_DASHED}

# Patch ingress to use the secret
kubectl patch deployment "nginx-helm-ingress-nginx-controller" \
    -n "ingress-nginx" \
    --type "json" \
    --patch '[
      {"op":"add","path":"/spec/template/spec/containers/0/args/-",
      "value":"--default-ssl-certificate=cert-manager-'${HOMEKUBE_DOMAIN_DASHED}'/tls-prod"}]'

echo "Installation done cert-manager"
fi
