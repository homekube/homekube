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

kubectl create namespace grafana
envsubst < create-storage.yaml | kubectl apply -f -

# provide default admin credentials e.g. admin/admin1234
kubectl create secret generic grafana-creds -n grafana \
  --from-literal=admin-user=admin \
  --from-literal=admin-password=admin1234

helm upgrade --install grafana grafana/grafana -n grafana --version=8.5.0 \
  --set persistence.enabled=true \
  --set persistence.existingClaim=grafana-pvc \
  --set persistence.subPath=grafana \
  --set admin.existingSecret=grafana-creds \
  -f datasource-dashboards.yaml

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
echo "Important NOTE: If this is installation connects to an existing pv credentials are taken from the existing database !!!"
echo "Installation done grafana"
fi # end of installation of grafana
