#!/bin/bash

if kubectl get ns | grep -q "^prometheus"; then
  echo "Skipping installation of prometheus because namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns prometheus'"
else

if ! helm repo list | grep -q "^prometheus-community"; then
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
fi
helm repo update

echo "Install prometheus"
kubectl create namespace prometheus
envsubst < create-storage.yaml | kubectl apply -f -

helm install prometheus -n prometheus --version=25.22.1 \
  --set alertmanager.enabled=false \
  --set pushgateway.enabled=false \
  --set server.persistentVolume.storageClass=managed-nfs-storage \
  --set server.persistentVolume.existingClaim=prometheus-pvc \
  prometheus-community/prometheus
echo "Installation done prometheus"

#kubectl apply -f ~/homekube/src/prometheus/ingress-prometheus.yaml
cat << EOF | envsubst | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-prometheus
  namespace: prometheus
spec:
  ingressClassName: nginx
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
