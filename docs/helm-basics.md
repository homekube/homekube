# Helm Basics by example

## Installation and Verification

Its easier to understand the principles of helm by executing a simple example.
Let's search the web for a sample **Who-am-i** application that just responds with the requests headers  

`https://www.google.de/search?q=helm+chart+who-am-i`

We are using one of the first matches and add the repo as suggested:

```bash
helm repo add halkeye https://halkeye.github.io/helm-charts/
```

Note that this is just a very simple chart. It just illustrates operations. We will see the
major benefits when installing more complex charts later.
The real power is helms templating solution which substitutes the charts placeholders
with parameters during installation. 

Before executing an installation its very easy to check what it will do.  
Just replace **`helm install ...`** with **`helm template ...`**


### Verify
Now lets evaluate the charts rendered templates before installation. 
No operation is performed, its just output of the manifests to be executed on install:

```bash
helm template whoami halkeye/whoami --version 0.3.2
```
Console output:
```text
# Source: whoami/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: whoami
  labels:
    app.kubernetes.io/name: whoami
    helm.sh/chart: whoami-0.3.2
    app.kubernetes.io/instance: whoami
    app.kubernetes.io/version: "v1.4.0"
    app.kubernetes.io/managed-by: Helm
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: whoami
    app.kubernetes.io/instance: whoami
---
# Source: whoami/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: whoami
  labels:
    app.kubernetes.io/name: whoami
    helm.sh/chart: whoami-0.3.2
    app.kubernetes.io/instance: whoami
    app.kubernetes.io/version: "v1.4.0"
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: whoami
      app.kubernetes.io/instance: whoami
  template:
    metadata:
      labels:
        app.kubernetes.io/name: whoami
        app.kubernetes.io/instance: whoami
    spec:
      containers:
        - name: whoami
          image: "containous/whoami:v1.4.0"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /health
              port: http
          readinessProbe:
            httpGet:
              path: /health
              port: http
          resources:
            {}
```

or pull the chart to a local folder for local analysis and modification

```bash
helm pull halkeye/whoami --version 0.3.2
```

### Install
```bash
kubectl create namespace whoami
helm install whoami halkeye/whoami -n whoami --version 0.3.2
```

Installer responds with
```text
NAME: whoami
LAST DEPLOYED: Tue Jul  7 10:57:26 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace whoami -l "app=whoami,release=whoami" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl port-forward $POD_NAME 8080:80
```

### Prove the results
For well-maintained repos as the `stable` or `bitnami` we installed earlier 
the usage instructions are usually properly maintained and accurate 
but in this case we need a few modifications to make it work. Execute:
```bash
export POD_NAME=$(kubectl get pods -l "app.kubernetes.io/name=whoami" -n whoami -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:80 --address=0.0.0.0
```

Opening `http://192.168.1.100:8080` in a browser  
(or execute `curl http://192.168.1.100:8080` in a terminal) results in: 
```text
Hostname: whoami-7b6ff5b56d-675pv
IP: 127.0.0.1
IP: ::1
IP: 10.1.43.16
IP: fe80::3c45:2eff:fe04:aef3
RemoteAddr: 127.0.0.1:38018
GET / HTTP/1.1
Host: 192.168.1.100:8080
User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/81.0.4044.138 Chrome/81.0.4044.138 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
Cache-Control: max-age=0
Connection: keep-alive
Upgrade-Insecure-Requests: 1
```

### Checking charts installed

Get a list of installed charts
```bash
helm list --all-namespaces
```
```text
NAME      	NAMESPACE     	REVISION	UPDATED                                 	STATUS  	CHART              	APP VERSION
metallb   	metallb-system	1       	2020-07-03 17:49:28.611030201 +0200 CEST	deployed	metallb-0.12.0     	0.8.1      
nginx-helm	ingress-nginx 	1       	2020-07-03 17:58:48.486130759 +0200 CEST	deployed	ingress-nginx-2.9.1	0.33.0     
whoami    	whoami       	1       	2020-07-07 13:30:21.940717018 +0200 CEST	deployed	whoami-0.3.2       	v1.4.0     
```

### Uninstall a chart

```bash
helm uninstall whoami --namespace=whoami
```

### Checking repos installed

Get a list of installed repos
```bash
helm repo list
```
```text
NAME         	URL                                             
stable       	https://kubernetes-charts.storage.googleapis.com
bitnami      	https://charts.bitnami.com/bitnami              
ingress-nginx	https://kubernetes.github.io/ingress-nginx      
halkeye      	https://halkeye.github.io/helm-charts/          
```

### Uninstall a repository

```bash
helm repo remove halkeye
```
