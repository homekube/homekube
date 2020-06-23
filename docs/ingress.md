# Ingress and MetalLb

Ingress is a very useful component for having a common entrypoint for multiple services.
We will use [![](../images/ico/color/homekube_16.png) Ingress](microk8s-addons.md#ingress)
together with [![](../images/ico/book_16.png) MetalLb](https://metallb.universe.tf) 
which serves as a replacement for cloud-based LoadBalancers. In a typical cloud environment all incoming
traffic will flow into a kubernetes cluster from the LoadBalancer and MetalLb is a compatible 
replacement for non-cloud installations.

## Preparation

Create an ingress working directory on your server and cd into that:
```bash
mkdir ~/k8s/ingress -p
cd ~/k8s/ingress
```
A ``pwd`` should now show something like `/home/mykube/k8s/ingress`.

## Installation

```bash
microk8s enable ingress metallb
```
When prompted for the portrange Enter `192.168.1.200 - 192.168.1.220`
as commented in [Prerequisites #3](../Readme.md#prerequisites)  
[![](../images/ico/github_16.png) More details ...](https://github.com/metallb/metallb)

## Configuration

As a next step we need to define a service which serves as an entrypoint for all traffic that is routed through
an Ingress. This might have been a part of the installation but there are a couple of configuration options so
we will do that now.

```bash
curl -O https://raw.githubusercontent.com/a-hahn/homekube/master/src/ingress/ingress-service.yaml
kubectl apply -f ingress-service.yaml

# or apply the manifest directly from the url
kubectl apply -f https://raw.githubusercontent.com/a-hahn/homekube/master/src/ingress/ingress-service.yaml
```

As a last step we configure the dashboard service. Thats basically the same as configuring a VirtualHost in Apache
or Nginx. 

```bash
curl -O https://raw.githubusercontent.com/a-hahn/homekube/master/src/ingress/ingress-dashboard.yaml
kubectl apply -f ingress-dashboard.yaml

# or apply the manifest directly from the url
kubectl apply -f https://raw.githubusercontent.com/a-hahn/homekube/master/src/ingress/ingress-dashboard.yaml
```

