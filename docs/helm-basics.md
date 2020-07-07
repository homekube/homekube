# Helm Basics

## Installation and Verification

We will install charts later for the various apps. Before executing an installation
its very easy to check what it will do. Just replace <install> with <template>

Let's install a sample application ('Who-am-i' app) randomly querying google 
`https://www.google.de/search?q=helm+chart+who-am-i`

We are using one of the first matches:

```bash
helm repo add halkeye https://halkeye.github.io/helm-charts/
```

### Verify
Now lets evaluate the charts rendered template before installation:
```bash
helm template halkeye/whoami --version 0.3.2
```

### Install
```bash
helm install whoami halkeye/whoami --version 0.3.2
```

Installer prompts with
```text
NAME: whoami
LAST DEPLOYED: Tue Jul  7 10:57:26 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app=whoami,release=whoami" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl port-forward $POD_NAME 8080:80
```

For well-maintained repos as the `stable` or `bitnami` repo that we installed earlier 
the usage instructions are usually properly maintained and accurate 
but is this case we need small modifications to make it work:
```bash
  export POD_NAME=$(kubectl get pods -l "app.kubernetes.io/name=whoami" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://192.168.1.100:8080 to use your application"
  kubectl port-forward $POD_NAME 8080:80 --address=0.0.0.0
```

Opening `http://192.168.1.100:8080` shows that our installation is working
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

### Checking all our helm installs

```bash
helm list --all-namespaces
```

### Uninstall a chart

```bash
helm uninstall whoami --namespace=default
```

### Show the configured repositories

```bash
helm repo list
```

### Uninstall a repository

```bash
helm repo remove halkeye
```
