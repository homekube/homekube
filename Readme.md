# Kubernetes at home for fun and education

[Homekube.org](https://homekube.org) aims to set up a full operational kubernetes environment on a baremetal Ubuntu server. 
The focus is getting something done first and improve your kubernetes skills step by step along a happy path.  

![](docs/images/Rasberry-Pi4-Stack.jpg)

Following this tutorial you should have Kubernetes and a sample application installed 
along with the most useful and popular administration components on your local Ubuntu server(s):

| App |![](docs/images/ico/color/homekube_16.png) Tutorial| ![](docs/images/ico/color/homekube_link_16.png) Service (AMD64)| ![](docs/images/ico/color/raspi_20.png) Service (ARM64 /Raspberry) |
|--------|--------|--------|---------|
| 'Who am I' echo service  |![](docs/images/ico/color/homekube_16.png) [whoami.md](docs/whoami.md) |[![](docs/images/ico/color/homekube_link_16.png) live](https://whoami.homekube.org)| [![](docs/images/ico/color/raspi_20.png) live](https://whoami.pi.homekube.org)|
| Kubernetes dashboard |![](docs/images/ico/color/homekube_16.png) [dashboard.md](docs/dashboard.md)|[![](docs/images/ico/color/homekube_link_16.png) login **demo/demo**](https://dashboard.homekube.org) | [![](docs/images/ico/color/raspi_20.png) login **demo/demo**](https://dashboard.pi.homekube.org) | 
| Portainer Kubernetes deployments |![](docs/images/ico/color/homekube_16.png) [portainer-deployments.md](docs/portainer-deployments.md) |
| Grafana monitoring |![](docs/images/ico/color/homekube_16.png) [grafana.md](docs/grafana.md)|[![](docs/images/ico/color/homekube_link_16.png) login **demo/demo**](https://grafana.homekube.org) | [![](docs/images/ico/color/raspi_20.png) login **demo/demo**](https://grafana.pi.homekube.org) | 
| Prometheus metrics |![](docs/images/ico/color/homekube_16.png) [prometheus.md](docs/prometheus.md)|[![](docs/images/ico/color/homekube_link_16.png) live](https://prometheus.homekube.org)|[![](docs/images/ico/color/raspi_20.png) live](https://prometheus.pi.homekube.org)| 
| Testing payloads and response times |![](docs/images/ico/color/homekube_16.png) [workload-testing.md](docs/workload-testing.md)|[![](docs/images/ico/color/homekube_link_16.png) Grafana](https://grafana.homekube.org) open 'Request Handling Performance' | 


## Project philosophy
There are many ways to install Kubernetes locally but for simplicity we'll follow Ubuntu's recommended [![](docs/images/ico/color/ubuntu_16.png) **MicroK8s installation recipes**](https://microk8s.io/docs).
With just a few commands we will setup a Kubernetes single node locally. For all further installs we'll primarily use helm commands so we are very close to what you'd do in a cloud environment.
For more complex setups including **Multi-Host Multi-Cluster** on a pile of Raspberrys see also the ![](docs/images/ico/color/homekube_16.png) [installation variants](docs/inst_readme.md).

## Requirements
Server requirements are:

* A 64bit PC or arm64 (e.g. Raspberry 4) or a Virtual Machine on any supporting OS
* An Ubuntu 22.04 LTS (20.04 LTS or 18.04 LTS will do also [or alternatives linux distros supporting snapd](https://snapcraft.io/docs/installing-snapd))
* At least 20G of disk space and 4G of memory are recommended
* An internet connection

## Base Installation

| Host                                                                                   | Container                                                                                                      |
|----------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| ![](docs/images/ico/color/homekube_16.png)[-> Host installation](docs/installation.md) | ![](docs/images/ico/color/homekube_16.png)[ -> 1) Setup environment](docs/inst_microk8s-lxc-macvlan.md)        |
|                                                                                        | ![](docs/images/ico/color/homekube_16.png)[ -> 2) Provision container(s)](docs/inst_provision-microk8s-lxc.md) |
|                                                                                        | [![](docs/images/ico/color/ubuntu_16.png) Read more about **Linux containers**](https://linuxcontainers.org)   |
| Very easy                                                                              | A few simple steps required                                                                                    |
| Single host / Single node                                                              | Single host / multiple clusters                                                                                |
| Not extendible                                                                         | Extendible see ![](docs/images/ico/color/homekube_16.png) [ installation variants](docs/inst_readme.md)        |

## Service installation

#### Quick tour

![](docs/images/ico/color/homekube_16.png) [ Dashboard](docs/dashboard.md) ->
![](docs/images/ico/color/homekube_16.png) [ Portainer](docs/portainer-deployments.md) ->
![](docs/images/ico/color/homekube_16.png)[ Helm I](docs/helm.md) ->
![](docs/images/ico/color/homekube_16.png)[ Helm / Echo Service](docs/helm-basics.md) ->
![](docs/images/ico/color/homekube_16.png) [ Echo service II](docs/whoami.md) 

#### Advanced tour
**Quick tour** ->
![](docs/images/ico/color/homekube_16.png)[ Ingress](docs/ingress.md) ->
![](docs/images/ico/color/homekube_16.png)[ Dashboard II](docs/dashboard-auth.md) ->
![](docs/images/ico/color/homekube_16.png)[ Nfs](docs/nfs.md) ->
![](docs/images/ico/color/homekube_16.png)[ Prometheus Metrics](docs/prometheus.md) ->
![](docs/images/ico/color/homekube_16.png) [ Grafana](docs/grafana.md)

#### Pro tour
**Advanced tour** ->
![](docs/images/ico/color/homekube_16.png)[ Cert manager](docs/cert-manager.md) ->
![](docs/images/ico/color/homekube_16.png)[ Testing response times and payloads](docs/workload-testing.md)
