
## Dashboard background

The MicroK8s docs contain a brief chapter on how to
[![](../images/ico/color/ubuntu_16.png) set up the dashboard](https://microk8s.io/docs/addon-dashboard).
There is a slight but annoying difference in the way the Microk8s people install the dashboard 
and how the upstream kubernetes resources do it.
Basically it breaks down that the official doc use their own namespace ``kubernetes-dashboard`` 
and MicroK8s is using the existing ``kube-system``.

Here are the differences for the curious: 

```bash
# Download the MicroK8s dashboard installation manifest
curl https://raw.githubusercontent.com/ubuntu/microk8s/master/microk8s-resources/actions/dashboard.yaml > microk8s-dashboard-yaml
# Download the 'official' community maintained mainifest
curl https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.1/aio/deploy/recommended.yaml > kubenernetes-dashboard.yaml
git diff --no-index microk8s-dashboard-yaml kubenernetes-dashboard.yaml
```

## Get token

To obtain a token for a given ServiceAccount name without using a script:

```bash
kubectl get secrets -n kubernetes-dashboard
```
resulting output similar to:
```
NAME                               TYPE                                  DATA   AGE
admin-user-token-274ww             kubernetes.io/service-account-token   3      5m20s
default-token-gzlbc                kubernetes.io/service-account-token   3      23m
...
simple-user-token-nj2qx            kubernetes.io/service-account-token   3      5m11s
```

The token names are generated and contain the secret name from the manifest e.g. ``admin-account-token``
and a random trailing sequence ``-274ww``.

## Port forwarding

Instead of exposing the service we can also port-forward the kubernetes-dashboard:

```bash
kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 10443:443 --address 0.0.0.0
``` 
The disadvantage of this approach is that `port-forward` blocks the terminal session and once the session
gets closed the command gets terminated.

## Cleanup

Cleanup simply by removing the dashboard namespace

```bash
kubectl delete namespace kubernetes-dashboard
```

We could also cleanup only parts of it:

```bash
kubectl delete -f <filename.yaml or url_of_a_yaml_file>
```
