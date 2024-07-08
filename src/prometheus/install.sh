#!/bin/bash

kubectl get ns prometheus
if [[ $?  -eq 0 ]]; then
  echo "Skipping installation of prometheus because namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns prometheus'"
else
echo "Install prometheus"
kubectl create namespace prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm install prometheus -n prometheus --version=14.11.1 \
  --set alertmanager.enabled=false \
  --set pushgateway.enabled=false \
  --set server.persistentVolume.storageClass=managed-nfs-storage \
  prometheus-community/prometheus
echo "Installation done prometheus"

#kubectl apply -f ~/homekube/src/prometheus/ingress-prometheus.yaml
cat << EOF | envsubst | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
  name: ingress-prometheus
  namespace: prometheus
spec:
  rules:
    - host: prometheus.${HOMEKUBE_DOMAIN}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: prometheus-server
                port:
                  number: 80
EOF
echo "Installation done prometheus"
fi # end of installation of prometheus
