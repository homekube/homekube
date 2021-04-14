# Helm

[![](images/ico/color/helm_16.png) Helm charts](https://helm.sh/) are a convenient way to install all sorts of curated applications in our cluster 
(like databases, dashboards, visualizations, ...).

- [![](images/ico/book_16.png) Helm hub](https://hub.helm.sh)
 is for Kubernetes what 
 [![](images/ico/book_16.png) Docker hub](https://hub.docker.com/) is for containers.
- Helm installation scripts are called **charts** and provide a simple to use templating solution
- Many curated and trusted charts already exist for popular applications
- Deployment of Helm charts is easier to maintain because they relieve from copying/pasting/modifying 
lengthy manifests with lots of details
- Helm charts are a good choice for **development/production** or 
[**blue/green deployments**](https://octopus.com/docs/deployment-patterns/blue-green-deployments)


[![](images/ico/color/helm_16.png) Read more about Helm 3 ...](https://helm.sh/blog/helm-3-released/)

### Configuration

Add a `alias helm='microk8s helm3'` line to your servers `~/.bash_aliases` and close/reopen the remote terminal 
and check with `alias` :

```bash
alias kubectl='microk8s kubectl'
alias helm='microk8s helm3'
```
Now Helm3 will be the default helm installation.

In many cases `microk8s enable <app>` serves the same purpose as `helm install <chart>`.
However helm charts have the benefit of more in-depth documentation and most of them offer 
many customization options. That's not always a benefit for beginners as its easy to drown
in options. But there is a huge benefit with helm charts as they will work
in any cloud environment. 
From an educational pov there is no difference between your single node 
microk8s home server and a multi node cluster.
In this tutorial we will prefer helm charts where it seems appropriate. 

### Adding applications

#### TL;DR

For the impatient lets just add some popular application catalogs to our installation.
We can then browse these catalogs and directly install helm charts from the command line. 

```bash
# 1) This is the most popular 'stable' helm catalog 
helm repo add stable https://charts.helm.sh/stable

# 2) Bitnami offers 'curated' and well maintained helm charts for many apps - see below
helm repo add bitnami https://charts.bitnami.com/bitnami

# 3) The 'official' nginx ingress resource which is maintained by the community
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# Get a list of all repos ready for installation
helm search repo
```
 
#### Details

1) [![](images/ico/github_16.png) Helm charts](https://github.com/helm/charts)
   are the canonical source for [![](images/ico/color/helm_16.png) Helm Hub](https://hub.helm.sh/)
   and usually the first place to shop for maintained and documented charts. If a chart is marked
   'DEPRECATED' follow the links to its new location or browse one of the other chart catalogs.
   ```bash
   # browse the stable repo or inspect a particular chart
   helm search repo stable
   helm show chart stable/prometheus
   ```   
2) [![](images/ico/book_16.png) Bitnami](https://bitnami.com/) as a well-known chart provider.
   Bitnami maintains a broad range of curated helm charts which (as of today) have the benefit of
   good documentation and good reputation.
   [![](images/ico/github_16.png) Bitnami on github](https://github.com/bitnami/charts)  
   Browse Bitnamis Kubernetes Helm [![](images/ico/github_16.png) repository online](https://github.com/bitnami/charts/tree/master/bitnami)
   ```bash
   # browse the bitnami repo
   helm search repo bitnami
   ```
   There is one notable downside of Bitnami charts as of today as they do not support Multiarch
   images - that means they will not work on ARM architectures (e.g. Raspberry).

**Congrats** - Now we have direct access to a broad range of applications - many of them ready to install with a single command.

## Next steps

![](images/ico/color/homekube_16.png)[ More about helm by example](helm-basics.md).

## Tutorials

 - [![](images/ico/color/youtube_16.png) ![](images/ico/instructor_16.png) 14:15 Helm and Helm Charts explained](https://www.youtube.com/watch?v=-ykwb1d0DXU) 
 [[Techworld with Nana](https://www.youtube.com/channel/UCdngmbVKX1Tgre699-XLlUA)]   
