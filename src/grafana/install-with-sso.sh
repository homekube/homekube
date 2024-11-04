#!/bin/bash

if kubectl get ns | grep -q "^grafana"; then
  echo "Skipping installation of grafana because namespace already exists"
  echo "If you want to reinstall execute: "
  echo "'kubectl delete ns grafana'"
  echo "'kubectl delete pv grafana-pv'"
  exit 1
else

if ! helm repo list | grep -q "^grafana"; then
  helm repo add grafana https://grafana.github.io/helm-charts
  helm repo update grafana
fi

echo "Install grafana"

envsubst < config-oauth-env.yaml > config-oauth.yaml

kubectl create namespace grafana
envsubst < create-storage.yaml | kubectl apply -f -

helm install grafana -n grafana --version=8.3.2 \
  --set persistence.enabled=true \
  --set persistence.existingClaim=grafana-pvc \
  --set persistence.subPath=grafana \
  -f datasource-dashboards.yaml \
  -f config-oauth.yaml \
  -f - grafana/grafana << EOF
# This should be part of config-oauth.yaml but unfortunately we can't replace envvars in imported yamls.
grafana.ini:
  server:
    root_url: https://grafana.${HOMEKUBE_DOMAIN}
EOF

#kubectl apply -f ~/homekube/src/grafana/ingress-grafana.yaml
cat << EOF | envsubst | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-grafana
  namespace: grafana
spec:
  ingressClassName: nginx
  rules:
    - host: grafana.${HOMEKUBE_DOMAIN}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: grafana
                port:
                  number: 80
EOF
echo "Installation done grafana"
fi # end of installation of grafana
