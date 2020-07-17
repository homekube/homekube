# Simple echo service

Follow the steps of [![](images/ico/color/homekube_16.png) Helm Basics](helm-basics.md) for deployment of a simple
'Who-am-i' service. Then create an Ingress for public access 
[![](images/ico/color/homekube_link_16.png) https://whoami.homekube.org](https://whoami.homekube.org).

```bash
cd ~/homekube/src/whoami
kubectl apply -f ingress-whoami.yaml
```
