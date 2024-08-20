
# Shutdown / Restart container

# Shutdown lxc k8s container  

Filesystems mounted in pods prevent a lxc container from shutting down. Forcefully shutting down nodes can take very long time. 
While in the container check if there are filesystems mounted
```bash
root@homekube:~# df -h -t nfs4
Filesystem                                                                                                Size  Used Avail Use% Mounted on
192.168.1.250:/Public/nfs/authdata                                                                        1.6T   44G  1.5T   3% /var/snap/microk8s/common/var/lib/kubelet/pods/b42462a2-a12e-4f88-af0c-e4c35c3886ba/volumes/kubernetes.io~nfs/postgres-pv
192.168.1.250:/Public/nfs/authdata/prometheus-prometheus-server-pvc-9417b67d-6627-4a65-b77f-c67f0dc171ca  1.6T   44G  1.5T   3% /var/snap/microk8s/common/var/lib/kubelet/pods/045e0be0-d823-4828-8926-1849095b3e65/volumes/kubernetes.io~nfs/pvc-9417b67d-6627-4a65-b77f-c67f0dc171ca
192.168.1.250:/Public/nfs/authdata/grafana-grafana-pvc-dcfdbb36-a67f-438b-bf2f-7085c87500e6               1.6T   44G  1.5T   3% /var/snap/microk8s/common/var/lib/kubelet/pods/44dde1bd-49e8-4850-b3c2-9e605a5b9a8d/volumes/kubernetes.io~nfs/pvc-dcfdbb36-a67f-438b-bf2f-7085c87500e6
```

Drain the node. This stops all pods. After drain repeat the filesystem check.
There should be no more file systems listed
```bash
kubectl drain <container> --ignore-daemonsets --delete-emptydir-data --timeout 60s
```

Stopping microk8s
```bash
lxc exec <container> -- microk8s stop
lxc exec <container> -- microk8s status
#lxc exec <container> -- snap stop microk8s --disable
#lxc stop <container> -f
```

## Restart the container
```bash
lxc exec <container> -- microk8s start
lxc exec <container> -- microk8s status
```

```bash
# starting pods which where uncordoned before
kubectl uncordon <container>
```

Check if persistent volume claims are bound
```bash
root@homekube:~# kubectl get pvc -A
NAMESPACE     NAME                                             STATUS   VOLUME                                          CAPACITY   ACCESS MODES   STORAGECLASS          VOLUMEATTRIBUTESCLASS   AGE
grafana       grafana                                          Bound    pvc-dcfdbb36-a67f-438b-bf2f-7085c87500e6        10Gi       RWO            managed-nfs-storage   <unset>                 29m
nfs-storage   pvc-nfs-client-nfs-subdir-external-provisioner   Bound    pv-nfs-client-nfs-subdir-external-provisioner   10Mi       RWO                                  <unset>                 19m
postgres      postgres-pvc                                     Bound    postgres-pv                                     1Gi        RWX            managed-nfs-storage   <unset>                 22h
prometheus    prometheus-server                                Bound    pvc-9417b67d-6627-4a65-b77f-c67f0dc171ca        8Gi        RWO            managed-nfs-storage   <unset>                 30m
```

# Useful commands for troubleshooting

## On the host

```bash
sudo dmesg -Tw  # kernel logs
journalctl -fe
```
