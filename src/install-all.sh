#!/bin/bash

# these are the external ips of the load balancer, e.g. the public entry points
if [[ -z $HOMEKUBE_PUBLIC_IPS ]]; then
  export HOMEKUBE_PUBLIC_IPS=192.168.1.200-192.168.1.200   # 192.168.1.48-192.168.1.49
fi
# the public domain of this site
if [[ -z $HOMEKUBE_DOMAIN ]]; then
  export HOMEKUBE_DOMAIN=homekube.org  # pi.homekube.org
fi
# The url of the nfs server
if [[ -z $HOMEKUBE_NFS_SERVER_URL ]]; then
  export HOMEKUBE_NFS_SERVER_URL=192.168.1.250   # 192.168.1.249
fi
# The path to your data on the nfs server
if [[ -z $HOMEKUBE_NFS_SERVER_PATH ]]; then
  export HOMEKUBE_NFS_SERVER_PATH=/Public/nfs/kubedata # /Public/nfs/pidata
fi

apt update
echo "Waiting for Microk8s ready state"
microk8s status --wait-ready
microk8s kubectl version --short
microk8s enable dns rbac helm3 metallb:${HOMEKUBE_PUBLIC_IPS}

###############################################################################
############################## install whoami #################################
###############################################################################
kubectl get ns whoami
if [[ $?  -eq 0 ]]; then
  echo "Skipping installation of demo whoami app because the namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns whoami' and run this script again"
else
echo "Install who-am-i demo application"
helm repo add halkeye https://halkeye.github.io/helm-charts/
kubectl create namespace whoami
helm install whoami halkeye/whoami -n whoami --version 0.3.2
kubectl scale --replicas=5 deployment.apps/whoami -n whoami

#kubectl apply -f ~/homekube/src/whoami/ingress-whoami.yaml
cat <<EOF | envsubst | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
  name: ingress-whoami
  namespace: whoami
spec:
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

###############################################################################
############################## install ingress ################################
###############################################################################
kubectl get ns ingress-nginx
if [[ $?  -eq 0 ]]; then
  echo "Skipping installation of nginx webserver because the namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns ingress-nginx' and run this script again"
else
echo "Install ingress web server"
kubectl create namespace ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install nginx-helm -n ingress-nginx --version=4.0.6 \
    -f - ingress-nginx/ingress-nginx << EOF
controller:
  metrics:
    enabled: true
    service:
      # important for detection of nginx datasource by prometheus
      annotations: {
        prometheus.io/scrape: "true" ,
      }
EOF
echo "Installation done ingress"
fi # end of installation of nginx webservice

###############################################################################
############################## install dashboard ##############################
###############################################################################
kubectl get ns kubernetes-dashboard
if [[ $?  -eq 0 ]]; then
  echo "Skipping installation of dashboard because namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns kubernetes-dashboard'"
else
echo "Install kubernetes dashboard"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml
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

###############################################################################
############################## install nfs client #############################
###############################################################################
kubectl get ns nfs-storage
if [[ $?  -eq 0 ]]; then
  echo "Skipping installation of nfs storage because namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns nfs-storage'"
else
echo "Install nfs service (client needs existing server)"
sudo apt install nfs-common -y

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
kubectl create namespace nfs-storage

helm install nfs-client --version=4.0.17 \
  --set storageClass.name=managed-nfs-storage --set storageClass.defaultClass=true \
  --set nfs.server=${HOMEKUBE_NFS_SERVER_URL} \
  --set nfs.path=${HOMEKUBE_NFS_SERVER_PATH} \
  --set nfs.mountOptions={nfsvers=3} \
  --namespace nfs-storage \
  nfs-subdir-external-provisioner/nfs-subdir-external-provisioner
echo "Installation done nfs client"
fi # end of installation of nfs storage

###############################################################################
############################## install prometheus #############################
###############################################################################
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

###############################################################################
############################## install grafana ################################
###############################################################################
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

helm install grafana -n grafana --version=6.42.2 \
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
## `path` must be /var/lib/grafana/dashboards/<provider_name>
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
EOF

#kubectl apply -f ~/homekube/src/grafana/ingress-grafana.yaml
cat << EOF | envsubst | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
  name: ingress-grafana
  namespace: grafana
spec:
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

###############################################################################
############################## finsished ######################################
###############################################################################
echo "Next steps: Installation of cert-manager"
echo "Cert manager automates creation and renewal of LetsEncrypt certificates"
echo "Follow docs/cert-manager.md"
