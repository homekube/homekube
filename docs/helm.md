# Helm

[![](images/ico/color/helm_16.png) Helm charts](https://helm.sh/) are a convenient way to install all sorts of curated applications in our cluster 
(like databases, dashboards, visualizations, ...).

- [![](images/ico/book_16.png) Helm hub](https://hub.helm.sh)
 is for Kubernetes what 
 [![](images/ico/book_16.png) Docker hub](https://hub.docker.com/) is for containers.
- Helm installation scripts are called **charts** and provide a simple to use templating solution
- Many curated and trusted charts already exist for popular applications
- Deployment of Helm charts is easier to maintain because they relieve from copying/pasting/modifying 
lengthy manifests.
- Helm charts are a good choice for **development/production** or 
[**blue/green deployments**](https://octopus.com/docs/deployment-patterns/blue-green-deployments)


[![](images/ico/color/helm_16.png) Read more about Helm 3 ...](https://helm.sh/blog/helm-3-released/)

### Configuration

Add a `alias helm='microk8s helm3'` line to your servers `~/.bash_aliases` and close/reopen the remote terminal 
and check with `alias` :

```bash
...
alias kubectl='microk8s kubectl'
alias helm='microk8s helm3'
...
```
Now Helm3 will be the default helm installation.

### Adding applications

Lets add a catalog of applications. In this step we will add 
[![](images/ico/book_16.png) Bitnami](https://bitnami.com/) as a well-known chart provider.
Bitnami maintains a broad range of curated helm charts which (as of today) have the benefit of
good documentation and good reputation.
[![](images/ico/github_16.png) Bitnami on github](https://github.com/bitnami/charts)  
Browse Bitnamis Kubernetes Helm [![](images/ico/github_16.png) repository online](https://github.com/bitnami/charts/tree/master/bitnami)

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami
```

**Congrats** - Now we have direct access to a broad range of applications - many of them ready to install with a single command.
