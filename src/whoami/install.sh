#!/bin/bash

kubectl get ns whoami
if [[ $?  -eq 0 ]]; then
  echo "Skipping installation of demo whoami app because the namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns whoami' and run this script again"
else
echo "Install who-am-i demo application"
helm repo add halkeye https://halkeye.github.io/helm-charts/
kubectl create namespace whoami
helm install whoami halkeye/whoami -n whoami --version 1.0.1
kubectl scale --replicas=5 deployment.apps/whoami -n whoami

#kubectl apply -f ~/homekube/src/whoami/ingress-whoami.yaml
cat <<EOF | envsubst | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-whoami
  namespace: whoami
spec:
  ingressClassName: nginx
  rules:
    - host: whoami.${HOMEKUBE_DOMAIN}
      http:
        paths:
          - backend:
              service:
                name: whoami
                port:
                  number: 80
            path: /
            pathType: Prefix
EOF
echo "Installation done who-am-i demo application"
fi # end if installation of whoami
