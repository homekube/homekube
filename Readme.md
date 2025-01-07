# Kubernetes at home for fun and education

[Homekube.org](https://homekube.org) aims to set up a full operational kubernetes environment on a baremetal Ubuntu server.
The focus is getting something done first and improve your kubernetes skills step by step along a happy path.
All installations are on AMD (PC) or ARM (Raspberry) or Proxmox hosts (docs t.b.d)
purely using containers (LXC/LXD or Incus (in contrast to VM based))

![](docs/images/Rasberry-Pi4-Stack.jpg)

Following this tutorial you should have Kubernetes and a sample application installed
along with the most useful and popular administration components on your local Ubuntu server(s). Installations cover
PC (AMD64), ARM64 (Raspbery Pi5), Proxmox and secured operation using Identity Access Managegment (IAM (Keycloak))

| App                                                                                                                                           | Online <br> AMD64                                                               | Online <br> Raspberry                                      | Online <br> Raspberry <br/> w Incus            | Proxmox<br> (docs t.b.d)                                                                    | Online IAM<br> Keycloak                                                                                                                                                                                        | 
|-----------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|-----------------------------------------------------------|-------------------------------------------------|---------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 'Who am I' echo service <br/>![](docs/images/ico/color/homekube_16.png) [whoami.md](docs/whoami.md)                                           | [![](docs/images/homekube_64.png)](https://whoami.homekube.org)                 | [![](docs/images/raspberry_64.png) ](https://whoami.pi.homekube.org)                         | [![](docs/images/raspberry_64.png) ](https://whoami.piincus.homekube.org)                         | [![](docs/images/proxmox_64.png) ](https://whoami.pm1.homekube.org)                         | [![](docs/images/keycloak_64.png) ](https://whoami.auth.homekube.org)                                                                                                                                          |
| Kubernetes dashboard <br/> ![](docs/images/ico/color/homekube_16.png) [dashboard.md](docs/dashboard.md)                                       | [![](docs/images/homekube_64.png) ](https://dashboard.homekube.org/#/pod?namespace=_all) | [![](docs/images/raspberry_64.png) ](https://dashboard.pi.homekube.org/#/pod?namespace=_all) | [![](docs/images/raspberry_64.png) ](https://dashboard.piincus.homekube.org/#/pod?namespace=_all) | [![](docs/images/proxmox_64.png) ](https://dashboard.pm1.homekube.org/#/pod?namespace=_all) | [![](docs/images/keycloak_64.png) ](https://dashboard.auth.homekube.org/#/pod?namespace=_all)                                                                                                                  |
| Grafana monitoring <br/>![](docs/images/ico/color/homekube_16.png) [grafana.md](docs/grafana.md)                                              | [![](docs/images/homekube_64.png)](https://grafana.homekube.org)                | [![](docs/images/raspberry_64.png) ](https://grafana.pi.homekube.org)                        | [![](docs/images/raspberry_64.png) ](https://grafana.piincus.homekube.org)                        | [![](docs/images/proxmox_64.png) ](https://grafana.pm1.homekube.org)                        | [![](docs/images/keycloak_64.png) ](https://grafana.auth.homekube.org)                                                                                                                                         | 
| Prometheus metrics <br/>![](docs/images/ico/color/homekube_16.png) [prometheus.md](docs/prometheus.md)                                        | [![](docs/images/homekube_64.png)](https://prometheus.homekube.org)             | [![](docs/images/raspberry_64.png) ](https://prometheus.pi.homekube.org)                     | [![](docs/images/raspberry_64.png) ](https://prometheus.piincus.homekube.org)                     | [![](docs/images/proxmox_64.png) ](https://prometheus.pm1.homekube.org)                     | [![](docs/images/keycloak_64.png) ](https://prometheus.auth.homekube.org)                                                                                                                                      | 
| Testing payloads and <br/>response times *1) <br/> ![](docs/images/ico/color/homekube_16.png) [workload-testing.md](docs/workload-testing.md) | [![](docs/images/homekube_64.png) ](https://grafana.homekube.org)               |  |                                                                                 |                                                                                             |
|                                                                                                                                               | | | |                                                                                             | [ **Logoff** <br/>![](docs/images/keycloak_64.png) ](https://dashboard.auth.homekube.org/oauth2/sign_out?rd=https%3A%2F%2Fkeycloak.auth.homekube.org%2Frealms%2Fhomekube%2Fprotocol%2Fopenid-connect%2Flogout) |

Where logins are required use **demo/demo** with only basic dashboard permissions to view namespaces, pods and logs.  
Or use **simple-user/s3cr3t** (supported by Keycloak SSO IAM) with dashboard read access on (almost) all objects.

## Project philosophy
The idea of this project is to set up a fully functional kubernetes environment on budget hardware - a PC / Server or a Raspberry Pi. While learning step by step the final setup
is a complete professional appliance with all major components integrated. All steps are explained in detail and accompanied by publicly accessible online demos.

There are many ways to install Kubernetes locally but for simplicity we'll follow Ubuntu's recommended [![](docs/images/ico/color/ubuntu_16.png) **MicroK8s installation recipes**](https://microk8s.io/docs).
With just a few commands we will setup a Kubernetes single node locally. For more complex setups including **Multi-Host Multi-Cluster** on a pile of Raspberrys see also the ![](docs/images/ico/color/homekube_16.png) [installation variants](docs/inst_readme.md).

## Requirements

* AMD64 (PC with 8GB and SSD) or a VM with 8GB dedicated storage **or**
* ARM64 (Paspberry Pi5 with 8GB and SSD strongly recommended (SD cards fail after a while) *2)
* External NAS drive  supporting NFS filesystem (e.g. another Raspberry) for sharing and archiving data

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