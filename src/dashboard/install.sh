#!/bin/bash

kubectl get ns kubernetes-dashboard
if [[ $?  -eq 0 ]]; then
  echo "Skipping installation of dashboard because namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns kubernetes-dashboard'"
else
echo "Install kubernetes dashboard"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: simple-user
  namespace: kubernetes-dashboard

---

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: simple-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: view
subjects:
- kind: ServiceAccount
  name: simple-user
  namespace: kubernetes-dashboard
EOF

HOMEKUBE_DASHBOARD_TOKEN=$(kubectl -n kubernetes-dashboard create token simple-user --duration 525600m)   # 10 years duration
if [ -z "$HOMEKUBE_DASHBOARD_TOKEN" ]
then
  echo "User ${HOMEKUBE_USER_NAME} not found. Probably you need to create the user first. See the 'create-admin-user.yaml'"
  exit 1
fi

cat << EOF | envsubst | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    ingress.kubernetes.io/ssl-redirect: "true"
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/backend-protocol: HTTPS
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    nginx.ingress.kubernetes.io/auth-url: https://httpbin.org/basic-auth/demo/demo
    nginx.ingress.kubernetes.io/configuration-snippet: |
      proxy_set_header "Authorization" "Bearer ${HOMEKUBE_DASHBOARD_TOKEN}" ;
  name: ingress-dashboard-service
  namespace: kubernetes-dashboard
spec:
  rules:
    - host: dashboard.${HOMEKUBE_DOMAIN}
      http:
        paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: kubernetes-dashboard
              port:
                number: 443
EOF
echo "Installation done dashboard"
fi # end of installation of kubernetes dashboard
