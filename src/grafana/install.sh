#!/bin/bash

kubectl get ns grafana
if [[ $?  -eq 0 ]]; then
  echo "Skipping installation of grafana because namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns grafana'"
else
echo "Install grafana"

kubectl create namespace grafana

helm repo add grafana https://grafana.github.io/helm-charts

helm install grafana -n grafana --version=8.3.2 \
  --set persistence.enabled=true \
  --set persistence.storageClassName=managed-nfs-storage \
  -f datasource-dashboards.yaml \
  -f - grafana/grafana << EOF
grafana.ini:
  auth:
    disable_login_form: true
  auth.generic_oauth:
    enabled: true
    org_role: Viewer
    org_name: Homekube
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
