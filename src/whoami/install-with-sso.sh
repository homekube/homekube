#!/bin/bash

if kubectl get ns | grep -q "^whoami"; then
  echo "Skipping installation of whoami because namespace already exists"
  echo "If you want to reinstall execute: "
  echo "'kubectl delete ns whoami'"
else

if ! helm repo list | grep -q "^whoami"; then
  helm repo add halkeye https://halkeye.github.io/helm-charts/
  helm repo update halkeye
fi

echo "Install who-am-i demo application"
kubectl create namespace whoami
helm install whoami halkeye/whoami -n whoami --version 1.0.1
kubectl scale --replicas=5 deployment.apps/whoami -n whoami

envsubst < oauth2/oauth2.yaml | kubectl apply -f -
envsubst < oauth2/ingress-sso.yaml | kubectl apply -f -

echo "Installation done who-am-i demo application"
fi # end if installation of whoami
