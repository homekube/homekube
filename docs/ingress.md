# Ingress and MetalLb

Ingress is a very useful component for having a common entrypoint for multiple services.
We will use [![](images/ico/color/homekube_16.png) Ingress](microk8s-addons.md#ingress)
together with [![](images/ico/book_16.png) MetalLb](https://metallb.universe.tf) 
which serves as a replacement for cloud-based LoadBalancers. In a typical cloud environment all incoming
traffic will flow into a kubernetes cluster from the LoadBalancer and MetalLb is a compatible 
replacement for non-cloud installations.

Data flow will be

```
                             Nginx      Dashboard
Internet -> LoadBalancer ->  Ingress -> service 
```

## Preparation

```bash
cd ~/homekube/src/ingress
```
A ``pwd`` should now show something like `/home/mykube/k8s/ingress`.

## Installation

```bash
microk8s enable ingress metallb
```
When prompted for the portrange Enter `192.168.1.200 - 192.168.1.220`
as commented in [Prerequisites #3](../Readme.md#prerequisites)  
[![](images/ico/github_16.png) More details ...](https://github.com/metallb/metallb)

## Configuration

As a next step we need to define a service which serves as an entrypoint for all traffic that is routed through
an Ingress. Our service configuration `ingress-service.yaml` accepts http and https connections on port 80 and 443
and forwards them to the appropriate endpoints of the ingress-controller-pod - that is an nginx runtime 
wrapped into a container. We configure a MetalLb LoadBalancer `192.168.1.200` ip which will accept the incoming
traffic. 

```bash
kubectl apply -f ingress-service.yaml
```

Finally we configure the dashboard service. If you have already configured Apache2 or Nginx reverse proxies 
this may be a bit familiar for you. The manifest type is `Ingress` and 
the noticeable difference is that configuration is done through annotations.
Read more about
[![](images/ico/color/kubernetes_16.png) Ingress configuration](https://kubernetes.io/docs/concepts/services-networking/ingress/).  
There is a long list of 
[![](images/ico/color/kubernetes_16.png) available annotations](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/).
Reference of
[![](images/ico/book_16.png) embedded variables](http://nginx.org/en/docs/http/ngx_http_core_module.html#variables)

We accept https incoming traffic unwrap it and wrap it again in https to forward it to the kubernetes dashboard.
It is an important detail that the Ingress manifest is defined in the same namespace  `namespace: kubernetes-dashboard`
where the dashboard service is defined.

```bash
kubectl apply -f ingress-dashboard.yaml
```
In your **local browser open `https://192.168.1.200`**  
Dashboard now opens via Ingress in addition to the previous configuration. 

![](images/dashboard-signin.png)

Note that we did not provide a certificate so far. 
Ingress will present your browser a `Kubernetes Ingress controller Fake Certificate`
certificate that is different from the one presented by the dashboard service and 
the default dashboard certificate. Although Chrome again shows the  `NET::ERR_CERT_AUTHORITY_INVALID`
error it will now show a `Proceed to 192.168.1.200 (unsafe)` option.

## Next steps

Lets create our own automated LetsEncrypt certificates with
[![](images/ico/color/homekube_16.png) Cert-Manager](cert-manager.md). 
