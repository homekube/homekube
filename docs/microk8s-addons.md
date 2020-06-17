## Microk8s AddOns

### DNS
[![](../images/ico/color/ubuntu_16.png) DNS](https://microk8s.io/docs/addon-dns) should always be anabled.
It will resolve internal and external references of the installed components.  
[![](../images/ico/color/kubernetes_16.png) Details ...](https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/) 
[![](../images/ico/github_16.png) More details ...](https://github.com/kubernetes/dns/blob/master/docs/specification.md)

### MetalLb
[Metallb](https://metallb.universe.tf) is a substitute for a cloud loadbalancer provided by a cloud service provider.
Thats the gateway from where all incoming traffic will flow into our kube.
You will be prompted for the portrange as commented [Prerequisites](#Prerequisites) 3) `192.168.1.200 - 192.168.1.220`  
[![](../images/ico/github_16.png) More details ...](https://github.com/metallb/metallb)

### Helm(3) charts
[![](../images/ico/color/helm_16.png) Helm charts](https://helm.sh/) are a convenient way to install all sorts of curated applications in our cluster 
(like databases, dashboards, visualizations, ...).
[Helm hub](https://hub.helm.sh) is for Kubernetes what [Docker hub](https://hub.docker.com/) is for containers. 
Helm charts are very convenient because they provide a simple to use templating solution.
Once you have to maintain similar variants of your deployments e.g. development/production or 
[blue/green runtime environments](https://octopus.com/docs/deployment-patterns/blue-green-deployments) they are a big time saver.  
[![](../images/ico/color/helm_16.png) more about Helm 3 ...](https://helm.sh/blog/helm-3-released/)

### Rbac
[![](../images/ico/color/kubernetes_16.png) Role-based access control](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
is a widely used security module that allows for detailed access constraints for all components in a cluster

### Ingress

An Ingress serves as an entrypoint into the cluster. In Kubernetes it serves the same purpose that an Apache or NGinx
reverse proxy does for a web application. In fact the default Ingress configuration is based on the nginx open source modules. 
Although all components are pluggable and there are lots of other configuration options which all have their strengths and weaknesses.
Its important to note that 2 different Ingress implementations exist.
[![](../images/ico/color/kubernetes_16.png) One is maintained by the Kubernetes community](https://kubernetes.github.io/ingress-nginx/)
 and is considered the
'mainstream' or default component. [![](../images/ico/book_16.png) The other is maintained by Nginx corporation](https://www.nginx.com/products/nginx/kubernetes-ingress-controller/)
 which is the creator of Nginx.   

While its good to habe a choice both are not interchangeable. They have differences in configuration and so you can't just one replace by the other.
Read more about [![](../images/ico/color/kubernetes_16.png) Ingress concepts](https://kubernetes.io/docs/concepts/services-networking/ingress/)

The term **Ingress** is a synonym for a **VirtualHost** in the Apache2 Universe or **virtual server** in traditional Nginx configurations.
The term **Ingress controller** refers to an Nginx server that is wrapped into a container under control of the kubernetes environment. 

A common data flow with an Ingress and 3 services is:

```
Internet -> LoadBalancer (Cloud or e.g. MetalLb) --> Ingress --> service1  
                                                             |-> service2
                                                             |-> service3
```
The same data flow without Ingress requires 3 LoadBalancer instances (which 3 times as costly in some cloud environments).
```
Internet --> LoadBalancer (Cloud or bare metal) --> service1  
         |-> LoadBalancer (Cloud or bare metal) --> service1  
         |-> LoadBalancer (Cloud or bare metal) --> service1  
```
### Dashboard

The dashboard is the default kubernetes community maintained ui.

![](../images/Dashboard.png)
