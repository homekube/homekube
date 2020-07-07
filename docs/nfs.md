# Nfs Server

```bash
kubectl create namespace nfs-storage
helm template nfs-client \
--set storageClass.name=managed-nfs-storage --set storageClass.defaultClass=true \
--set nfs.server=192.168.1.95 --set nfs.path=/srv/nfs/kubedata \
--namespace nfs-storage \
stable/nfs-client-provisioner
```

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes-incubator/external-storage/master/nfs-client/deploy/test-claim.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-incubator/external-storage/master/nfs-client/deploy/test-pod.yaml
kubectl delete pod test-pod
kubectl delete pvc test-claim
```


```bash
helm list --all-namspaces
helm uninstall nfs-client --namespace=nfs-storage
```



