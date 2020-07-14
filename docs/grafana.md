# Grafana


```bash
cd ~/homekube/src/grafana

kubectl create namespace grafana

kubectl create secret generic grafana-creds -n grafana \
  --from-literal=GF_SECURITY_ADMIN_USER=admin \
  --from-literal=GF_SECURITY_ADMIN_PASSWORD=admin1234

kubectl apply -f datasource-prometheus-secret.yaml

# works only with sidecar.dashboards.enabled=true
#kubectl -n grafana create cm grafana-dashboard-nginx-performance --from-file=dashboards/nginx-request-handling-performance-2m.json
#kubectl -n grafana label cm grafana-dashboard-nginx-performance grafana_dashboard=nginx-performance

#kubectl -n grafana create cm grafana-dashboard-nginx --from-file=https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/grafana/dashboards/nginx.json
#kubectl -n grafana label cm grafana-dashboard-nginx grafana_dashboard=nginx

helm install grafana -n grafana --version=5.3.3 \
-f datasource-dashboards.yaml \
--set persistence.enabled=true \
--set persistence.storageClassName=managed-nfs-storage \
--set admin.existingSecret=grafana-creds \
--set admin.userKey=GF_SECURITY_ADMIN_USER,admin.passwordKey=GF_SECURITY_ADMIN_PASSWORD \
stable/grafana

#--set sidecar.datasources.enabled=true \
#--set sidecar.dashboards.enabled=true \

```

