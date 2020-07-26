# Kubernetes at home for fun and education

Homekube aims to set up a full operational kubernetes environment on a baremetal Ubuntu server. 
The focus is getting something done first and improve your kubernetes skills step by step along a happy path.  

Following this tutorial you should have Kubernetes and a sample application installed 
along with the most useful and popular administration components on your local Ubuntu server:

| App |![](docs/images/ico/color/homekube_16.png) Tutorial| ![](docs/images/ico/color/homekube_link_16.png) Service| ![](docs/images/ico/color/raspi_20.png) Raspberry |
|--------|--------|--------|---------|
| 'Who am I' echo service  |![](docs/images/ico/color/homekube_16.png) [whoami.md](docs/whoami.md) |[![](docs/images/ico/color/homekube_link_16.png) live](https://whoami.homekube.org)| [![](docs/images/ico/color/raspi_20.png) live](https://whoami.pi.homekube.org)|
| Kubernetes dashboard |![](docs/images/ico/color/homekube_16.png) [dashboard.md](docs/dashboard.md)|[![](docs/images/ico/color/homekube_link_16.png) login **demo/demo**](https://dashboard.homekube.org) | [![](docs/images/ico/color/raspi_20.png) login **demo/demo**](https://dashboard.pi.homekube.org) | 
| Grafana monitoring |![](docs/images/ico/color/homekube_16.png) [grafana.md](docs/grafana.md)|[![](docs/images/ico/color/homekube_link_16.png) login **demo/demo**](https://grafana.homekube.org) | [![](docs/images/ico/color/raspi_20.png) login **demo/demo**](https://grafana.pi.homekube.org) | 
| Prometheus metrics |![](docs/images/ico/color/homekube_16.png) [prometheus.md](docs/prometheus.md)|[![](docs/images/ico/color/homekube_link_16.png) live](https://prometheus.homekube.org)|[![](docs/images/ico/color/raspi_20.png) live](https://prometheus.pi.homekube.org)| 
| Testing payloads and response times |![](docs/images/ico/color/homekube_16.png) [workload-testing.md](docs/workload-testing.md)|[![](docs/images/ico/color/homekube_link_16.png) Grafana](https://grafana.homekube.org) open 'Request Handling Performance' | 


## Project philosophy
There are many ways to install Kubernetes locally but for simplicity we'll follow Ubuntu's recommended [![](docs/images/ico/color/ubuntu_16.png) **MicroK8s installation recipes**](https://microk8s.io/docs).
With just a few commands we will setup a Kubernetes single node locally. For all further installs we'll primarily use helm commands so we are very close to what you'd do in a cloud environment.

## Requirements
Server requirements are:

* A 64bit PC or arm64 (e.g. Raspberry 4) or a Virtual Machine on any supporting OS
* An Ubuntu 20.04 LTS (18.04 LTS or 16.04 LTS will do also [or alternatives linux distros supporting snapd](https://snapcraft.io/docs/installing-snapd))
* At least 20G of disk space and 4G of memory are recommended
* An internet connection


#### Quick tour

![](docs/images/ico/color/homekube_16.png)[ Installation](docs/installation.md) ->
![](docs/images/ico/color/homekube_16.png) [ Dashboard](docs/dashboard.md) ->
![](docs/images/ico/color/homekube_16.png)[ Helm I](docs/helm.md) ->
![](docs/images/ico/color/homekube_16.png)[ Helm / Echo Service](docs/helm-basics.md) ->
![](docs/images/ico/color/homekube_16.png) [ Echo service II](docs/whoami.md) 

#### Advanced tour
![](docs/images/ico/color/homekube_16.png)[ Quick tour](Readme.md#quick-tour) ->
![](docs/images/ico/color/homekube_16.png)[ Ingress](docs/ingress.md) ->
![](docs/images/ico/color/homekube_16.png)[ Dashboard II](docs/dashboard-auth.md) ->
![](docs/images/ico/color/homekube_16.png)[ Nfs](docs/nfs.md) ->
![](docs/images/ico/color/homekube_16.png)[ Prometheus Metrics](docs/prometheus.md) ->
![](docs/images/ico/color/homekube_16.png) [ Grafana](docs/grafana.md)

#### Pro tour
![](docs/images/ico/color/homekube_16.png)[ Advanced tour](Readme.md#advanced-tour) ->
![](docs/images/ico/color/homekube_16.png)[ Cert manager](docs/cert-manager.md) ->
![](docs/images/ico/color/homekube_16.png)[ Testing response times and payloads](docs/workload-testing.md)
