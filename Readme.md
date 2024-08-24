# Kubernetes at home for fun and education

[Homekube.org](https://homekube.org) aims to set up a full operational kubernetes environment on a baremetal Ubuntu server. 
The focus is getting something done first and improve your kubernetes skills step by step along a happy path.  

![](docs/images/Rasberry-Pi4-Stack.jpg)

Following this tutorial you should have Kubernetes and a sample application installed 
along with the most useful and popular administration components on your local Ubuntu server(s):

| App                                          |Tutorial| Online <br> AMD64                                                               | Online <br> Raspberry                                      | Online IAM<br> Keycloak                  
|----------------------------------------------|--------|---------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| 'Who am I' echo service                      |![](docs/images/ico/color/homekube_16.png) [whoami.md](docs/whoami.md) | [![](docs/images/homekube_64.png)](https://whoami.homekube.org)                 | [![](docs/images/raspberry_64.png) ](https://whoami.pi.homekube.org)                         | [![](docs/images/keycloak_64.png) ](https://whoami.auth.homekube.org) |
| Kubernetes dashboard                         |![](docs/images/ico/color/homekube_16.png) [dashboard.md](docs/dashboard.md)| [![](docs/images/homekube_64.png) ](https://dashboard.homekube.org/#/pod?namespace=_all) | [![](docs/images/raspberry_64.png) ](https://dashboard.pi.homekube.org/#/pod?namespace=_all) | [![](docs/images/keycloak_64.png) ](https://dashboard.auth.homekube.org/#/pod?namespace=_all) |
| Grafana monitoring                           |![](docs/images/ico/color/homekube_16.png) [grafana.md](docs/grafana.md)| [![](docs/images/homekube_64.png)](https://grafana.homekube.org)                | [![](docs/images/raspberry_64.png) ](https://grafana.pi.homekube.org)                        | [![](docs/images/keycloak_64.png) ](https://grafana.auth.homekube.org) | 
| Prometheus metrics                           |![](docs/images/ico/color/homekube_16.png) [prometheus.md](docs/prometheus.md)| [![](docs/images/homekube_64.png)](https://prometheus.homekube.org)             | [![](docs/images/raspberry_64.png) ](https://prometheus.pi.homekube.org)                     | [![](docs/images/keycloak_64.png) ](https://prometheus.auth.homekube.org) | 
| Testing payloads and response times <br> *1) |![](docs/images/ico/color/homekube_16.png) [workload-testing.md](docs/workload-testing.md)| [![](docs/images/homekube_64.png) ](https://grafana.homekube.org)               |                                                                                                    |

Where logins are required use **demo/demo** with only basic dashboard permissions to view namespaces, pods and logs.  
Or use **simple-user/s3cr3t** (supported by Keycloak SSO IAM) with dashboard read access on (almost) all objects.   
Then [**Logoff from SSO**](https://dashboard.auth.homekube.org/oauth2/sign_out?rd=https%3A%2F%2Fkeycloak.auth.homekube.org%2Frealms%2Fhomekube%2Fprotocol%2Fopenid-connect%2Flogout)

## Project philosophy
The idea of this project is to set up a fully functional kubernetes environment on budget hardware - a PC / Server or a Raspberry Pi. While learning step by step the final setup 
is a complete professional appliance with all major components integrated. All steps are explained in detail and accompanied by publicly accessible online demos. 

There are many ways to install Kubernetes locally but for simplicity we'll follow Ubuntu's recommended [![](docs/images/ico/color/ubuntu_16.png) **MicroK8s installation recipes**](https://microk8s.io/docs).
With just a few commands we will setup a Kubernetes single node locally. For more complex setups including **Multi-Host Multi-Cluster** on a pile of Raspberrys see also the ![](docs/images/ico/color/homekube_16.png) [installation variants](docs/inst_readme.md).

## Requirements

* A PC / Server or arm64 (e.g. Raspberry 4 or 5) or a Virtual Machine with 4GB memory (8GB recommended) *2)
* When using a device without persistent memory (e.g. Raspberry) an external NAS drive supporting NFS filesystem.

## Base Setup

This tutorial focuses on setting up a containerized environment using a container runtime. *3)  
While its more complex than direct installation it offers the additional benefit of running multiple containers / instances of the target hardware.

![](docs/images/ico/color/homekube_16.png)[ Setup environment](docs/inst_microk8s-lxc-macvlan.md)  -> ![](docs/images/ico/color/homekube_16.png)[ Provision container(s)](docs/inst_provision-microk8s-lxc.md) 

## TLDR; Service installation

Use the (semi-) automated scripts in ``src/install-all.sh`` (without Keycloak SSO)  
or ``src/install-with-sso1.sh`` and ``src/install-with-sso2.sh`` (includes postgres db and keycloak)

## Service installation

A step by step approach

### Quick tour

![](docs/images/ico/color/homekube_16.png) [ Dashboard](docs/dashboard.md) ->
![](docs/images/ico/color/homekube_16.png)[ Helm I](docs/helm.md) ->
![](docs/images/ico/color/homekube_16.png)[ Helm / Echo Service](docs/helm-basics.md) ->
![](docs/images/ico/color/homekube_16.png) [ Echo service II](docs/whoami.md) 

### Advanced tour I
**Quick tour** ->
![](docs/images/ico/color/homekube_16.png)[ Ingress](docs/ingress.md) ->
![](docs/images/ico/color/homekube_16.png)[ Dashboard II](docs/dashboard-auth.md) ->
![](docs/images/ico/color/homekube_16.png)[ Nfs](docs/nfs.md) ->
![](docs/images/ico/color/homekube_16.png)[ Prometheus Metrics](docs/prometheus.md) ->
![](docs/images/ico/color/homekube_16.png) [ Grafana](docs/grafana.md)

### Advanced tour II
**Advanced tour I** ->
![](docs/images/ico/color/homekube_16.png)[ Cert manager](docs/cert-manager.md) ->
![](docs/images/ico/color/homekube_16.png)[ Testing response times and payloads](docs/workload-testing.md)

### Pro tour 
**Advanced tour II** ->
![](docs/images/ico/color/homekube_16.png)[ Postgres Storage](docs/postgres.md) ->
![](docs/images/ico/color/homekube_16.png)[ Keycloak installation](docs/keycloak-installation.md) ->
![](docs/images/ico/color/homekube_16.png)[ Keycloak config](docs/keycloak-configuration.md) ->
![](docs/images/ico/color/homekube_16.png)[ Dashboard SSO / Oauth2-proxy](docs/oauth-proxy.md)

<br>


##### Footnotes
*1)  -> open dashboard 'Request Handling Performance'  
*2)  An ethernet connection to the target device is required. WLAN does not work out of the box.  
**NOTE** that if you want to use a VM on your developers workstation as a target the installation requires additional steps not covered in this tutorial.  
*3) If you prefer a simpler approach follow ![](docs/images/ico/color/homekube_16.png)[ skipping containers](docs/installation.md) 