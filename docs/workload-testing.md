# Workload testing

## Preparation

Prerequisites are: 
- [![](images/ico/color/homekube_16.png) Ingress](ingress.md)
- [![](images/ico/color/homekube_16.png) Prometheus](prometheus.md)
- [![](images/ico/color/homekube_16.png) Grafana](grafana.md)

```bash
cd ~/homekube/src/test/workload 
```

## Installation

```bash
kubectl create namespace test-workload

kubectl create deployment whoami --image=containous/whoami -n test-workload
kubectl expose deployment whoami --type=NodePort --port=80 -n test-workload
kubectl get service whoami -n test-workload

kubectl apply -f whoami-ingress.yaml

```


```bash
while true; do curl -X GET 192.168.1.40 -H 'host: who-am-i.info'; done
```

```bash
while true; do curl -X GET 192.168.1.40/?wait=100ms -H 'host: who-am-i.org'; done
```