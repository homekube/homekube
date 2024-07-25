#!/bin/bash

kubectl get ns grafana
if [[ $?  -eq 0 ]]; then
  echo "Skipping installation of grafana because namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns grafana'"
else
echo "Install grafana"

kubectl create namespace grafana

helm repo add grafana https://grafana.github.io/helm-charts

# provide default admin credentials e.g. admin/admin1234
kubectl create secret generic grafana-creds -n grafana \
  --from-literal=admin-user=admin \
  --from-literal=admin-password=admin1234

helm install grafana -n grafana --version=8.3.2 \
  --set persistence.enabled=true \
  --set persistence.storageClassName=managed-nfs-storage \
  --set admin.existingSecret=grafana-creds \
  -f - grafana/grafana << EOF
##
## Configure grafana datasources
## ref: https://grafana.com/docs/grafana/latest/administration/provisioning/#data-sources
##
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
    - name: Prometheus
      type: prometheus
      orgId: 1
      url: http://prometheus-server.prometheus
      isDefault: true
      version: 1
      editable: true

## Configure grafana dashboard providers
## ref: https://grafana.com/docs/grafana/latest/administration/provisioning/#dashboards
##
## path must be /var/lib/grafana/dashboards/<provider_name>
##
dashboardProviders:
  dashboardproviders.yaml:
    apiVersion: 1
    providers:
    - name: prometheus
      orgId: 1
      folder: ''
      type: file
      disableDeletion: false
      editable: true
      options:
        path: /var/lib/grafana/dashboards/prometheus

## Configure grafana dashboard to import
## NOTE: To use dashboards you must also enable/configure dashboardProviders
## ref: https://grafana.com/dashboards
##
## dashboards per provider, use provider name as key.
##
dashboards:
  prometheus:
    nginx-dashboard:
      url: https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/grafana/dashboards/nginx.json
    nginx-dashboard-request-handling:
      # Thats the original that did not work properly:
      #url: https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/grafana/dashboards/request-handling-performance.json
      # Thats the modified version before transferring to homekube.org
      #url: https://gist.githubusercontent.com/a-hahn/6b5ef83b747da5f8ba087eb81e18ad08/raw/4f024ee6d3ca158ee2c7febe7e03e507c4c500df/nginx-request-handling-performance-2m.json
      url: https://raw.githubusercontent.com/homekube/homekube/master/src/grafana/dashboards/nginx-request-handling-performance-2m.json
    grafana-node-exporter:
      # Ref: https://grafana.com/dashboards/11207
      gnetId: 11207
      datasource: Prometheus
    kubernetes-cluster-monitoring:
      # Ref: https://grafana.com/dashboards/315
      gnetId: 315
      datasource: Prometheus

## Configure oauth2 authentication
assertNoLeakedSecrets: false
grafana.ini:
  server:
    root_url: https://grafana.auth.homekube.org
  auth:
    disable_login_form: true
  auth.generic_oauth:
    enabled: true
    name: Keycloak-OAuth
    allow_sign_up: true
    client_id: homekube-dashboard
    client_secret: Lyzym6uI7dUYjyeKf40syWPnBH9IIOCI
    scopes: openid email profile offline_access roles
    email_attribute_path: email
    login_attribute_path: email
    name_attribute_path: email
    auth_url: https://auth.oops.de/realms/homekube/protocol/openid-connect/auth
    token_url: https://auth.oops.de/realms/homekube/protocol/openid-connect/token
    api_url: https://auth.oops.de/realms/homekube/protocol/openid-connect/userinfo
    role_attribute_path: contains(roles[*], 'admin') && 'Admin' || contains(roles[*], 'editor') && 'Editor' || 'Viewer'

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
