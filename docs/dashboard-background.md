
## Dashboard background

The MicroK8s docs contains a brief chapter on how to
[![](../images/ico/color/ubuntu_16.png) set up the dashboard](https://microk8s.io/docs/addon-dashboard).
There is a slight but annoying difference in the way the Microk8s people install the dashboard 
and how the upstream kubernetes resources do it.
Basically it breaks down that the official version use their own namespace `kubernetes-dashboard` 
and MicroK8s is using the existing `kube-system` namespace.

Execute a `git diff` to see the differences: 

```bash
# Download the MicroK8s dashboard installation manifest
curl https://raw.githubusercontent.com/ubuntu/microk8s/master/microk8s-resources/actions/dashboard.yaml > microk8s-dashboard-yaml
# Download the 'official' community maintained mainifest
curl https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.1/aio/deploy/recommended.yaml > kubenernetes-dashboard.yaml
git diff --no-index microk8s-dashboard-yaml kubenernetes-dashboard.yaml
```

The MicroK8s docs on the dashboard is rather short and references the upstream (mainstream) docs for more details 
but you can't execute any of those scripts without running into errors because of the different namespaces.
With different namespaces its also easier to cleanup and start again from the beginning without breaking other
parts of the installation.

## Get token

To obtain a token for a given ServiceAccount name without using a script:

```bash
kubectl get secrets -n kubernetes-dashboard
```
resulting output contains lines like:
```
NAME                               TYPE                                  DATA   AGE
admin-user-token-274ww             kubernetes.io/service-account-token   3      5m20s
default-token-gzlbc                kubernetes.io/service-account-token   3      23m
...
simple-user-token-nj2qx            kubernetes.io/service-account-token   3      5m11s
```

The token names are generated and contain the secret name from the manifest e.g. `admin-account-token`
and a random trailing sequence `-274ww`.

Once the name of the token is known we can retrieve its details:

```bash
kubectl describe secret admin-user-token-274ww -n kubernetes-dashboard 
```

## Exposing dashboard

The dashboard service can also be exposed permanently:

```bash
kubectl expose service kubernetes-dashboard --external-ip 192.168.1.100 --port 10443 --target-port 8443 --name dashboard -n kubernetes-dashboard
``` 
Check with the browser or on the command line of a **local ! terminal**:
  
```bash
curl -k https://192.168.1.100:10443
```
## Cleanup

Remove everything simply by removing the dashboard namespace:

```bash
kubectl delete namespace kubernetes-dashboard
```
```bash
# cleanup the exposed dashboard service only:
kubectl delete service dashboard -n kubernetes-dashboard
# or cleanup instructions we installed from a file or url. example:
kubectl delete -f create-admin-user.yaml
```
