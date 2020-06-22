# Ingress and MetalLb

Ingress is a very useful component for having a common entrypoint for multiple services.
We will use [![](../images/ico/color/homekube_16.png) Ingress](microk8s-addons.md#ingress)
together with [![](../images/ico/book_16.png) MetalLb](https://metallb.universe.tf) 
which serves as a replacement for cloud-based LoadBalancers. In a typical cloud environment all incoming
traffic will flow into a kubernetes cluster from the LoadBalancer and MetalLb is a compatible 
replacement for non-cloud installations.

```bash
microk8s enable ingress metallb
```
When prompted for the portrange Enter `192.168.1.200 - 192.168.1.220`
as commented in [Prerequisites #3](../Readme.md#prerequisites)  
[![](../images/ico/github_16.png) More details ...](https://github.com/metallb/metallb)

