# Grafana


```bash
cd ~/homekube/src/grafana

kubectl create namespace grafana

kubectl create secret generic grafana-creds -n grafana \
  --from-literal=GF_SECURITY_ADMIN_USER=admin \
  --from-literal=GF_SECURITY_ADMIN_PASSWORD=admin1234

kubectl apply -f datasource-prometheus-secret.yaml

helm install grafana -n grafana --version=5.3.3 \
--set persistence.enabled=true \
--set persistence.storageClassName=managed-nfs-storage \
--set admin.existingSecret=grafana-creds \
--set admin.userKey=GF_SECURITY_ADMIN_USER,admin.passwordKey=GF_SECURITY_ADMIN_PASSWORD \
--set sidecar.datasources.enabled=true
stable/grafana

```
