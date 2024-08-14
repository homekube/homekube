# NFS Storage

Network File System is a handy storage option for almost any local network.
Although setup is slightly more complex than local storage it offers much better 
scalability and usage options. While local storage is fast because as it is tied 
to a single node it is also difficult to migrate on installation changes 
or when a cluster has more than one node. 

NFS storage consists of a server and a client module. The server can be installed anywhere
in the local network or it can be on the same node as the client.

## Preparation
Lets check if any parts of nfs are already installed:
```bash
cd ~/homekube/src/storage/nfs 
dpkg -l nfs*
```
Terminal output shows that neither client nor server are installed:
```text
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name                        Version            Architecture       Description
+++-===========================-==================-==================-===========================================================
un  nfs-common                  <none>             <none>             (no description available)
un  nfs-kernel-server           <none>             <none>             (no description available)
```

### Preparing the server

**Skip this section** if you already have a nfs server in your local network with
storage available.

```bash
sudo ./create-nfs-server.sh
dpkg -l nfs*
```
```text
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name                        Version            Architecture       Description
+++-===========================-==================-==================-===========================================================
ii  nfs-common                  1:1.3.4-2.1ubuntu5 amd64              NFS support files common to client and server
ii  nfs-kernel-server           1:1.3.4-2.1ubuntu5 amd64              support for NFS kernel server
```
As indicated by `'ii'` status now both server and common (client) are now installed.

### Preparing the client

**Skip this section** if you have already installed the server (which includes the client)
or if you already have a client on your node.

```bash
sudo apt install nfs-common
dpkg -l nfs*
```
```text
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name                        Version            Architecture       Description
+++-===========================-==================-==================-===========================================================
ii  nfs-common                  1:1.3.4-2.1ubuntu5 amd64              NFS support files common to client and server
un  nfs-kernel-server           <none>             <none>             (no description available)
```

## Installing the manifest

**NOTE** maintenance of kubernetes nfs support has moved to [![](images/ico/color/kubernetes_16.png) Kubernets-Sigs](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner) 
Instructions were updated below.

Next we install the kubernetes part of the storage provider. Parameters are
- storageClass.name=**managed-nfs-storage**  
This parameter needs to match all correspondings pvc storage class references
(see test below).
- storageClass.defaultClass=**true**  
All pvc that do not specify a storageClass ref will use this default. Can be ommitted.
- nfs.server=**192.168.1.100**  
Ip of any nfs-server in the network (or server on local node).  
**NOTE** that `localhost` or `127.0.0.1` will not work !
- nfs.path=**/srv/nfs/kubedata** is the path to our data storage on the server.  
- nfs.mountOptions={nfsvers=3} is important if your server only supports versions up to vers=3.  
This is true for many Nas systems including QNAP

```bash
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
kubectl create namespace nfs-storage

helm install nfs-client --version=4.0.17 \
    --set storageClass.name=managed-nfs-storage --set storageClass.defaultClass=true \
    --set nfs.server=192.168.1.100 \
    --set nfs.path=/srv/nfs/kubedata \
    --set nfs.mountOptions={nfsvers=4} \
    --namespace nfs-storage \ 
    nfs-subdir-external-provisioner/nfs-subdir-external-provisioner
```
```bash
NAME: nfs-client
LAST DEPLOYED: Sun Nov 14 14:40:14 2021
NAMESPACE: nfs-storage
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

### Testing
Lets create a sample pvc and a sample pod that writes a success message 
to the servers storage.
```bash
kubectl apply -f test-nfs-storage.yaml
```

Navigate to the **storage folder on the server** and check its contents.
There is a folder created with **`<pvc-namespace>-<pvc-name>-<resource-id>`**
(pvc=persistent volume claim):

```bash
ls -la /srv/nfs/kubedata/
drwxrwxrwx 2 root root 4096 Jul  7 17:57 default-test-claim-pvc-ed7d7ff9-a3de-4fa3-a83e-624ebb664a9f
```
Inside the folder there is an empty file `SUCCESS` created by the test pod.

Now lets remove our test code
```bash
kubectl delete -f test-nfs-storage.yaml
```
### Troubleshooting

When the volume claims are left in state ``Pending`` troubleshooting can become quite cumbersome as there are no obvious error
messages. Especially when binding to nfs storage it can be helpful to try out the different mount
options of the nfs storage. There exist different nfs versions (2,3,4) and especially when using NAS devices for storage
and after a software update of the NAS device used for Homekube the former ``nfsvers=3`` didn't work anymore.

```
  --set nfs.mountOptions={nfsvers=3} \
```

### Installation options

Removing the testing volume claim will also **delete** the folder from
the server although an archive-folder is created. If we want storage to be kept when
a persistent volume claim is deleted we need to change the reclaim policy with another parameter:  

`--set storageClass.reclaimPolicy=Retain`  

[![](images/ico/color/helm_16.png) ![](images/ico/github_16.png) More options ...](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner/tree/master/charts/nfs-subdir-external-provisioner) 

### Cleanup
In case we want to get rid of the nfs-storage

```bash
helm uninstall nfs-client --namespace=nfs-storage
helm list --all-namespaces
```

Additionally remove any previously installed client/server packages on the server.  
**CAUTION** Executing `sudo apt purge ...` might delete data previously installed  
```bash
sudo apt remove nfs-kernel-server -y   # remove the server packages
sudo apt purge nfs-kernel-server -y    # remove config files for server
sudo apt remove nfs-common -y          # remove the client packages
sudo apt purge nfs-common -y           # remove config files for client
```

## Tutorials

 - [![](images/ico/color/youtube_16.png) ![](images/ico/instructor_16.png) 21:13 Kubernetes volumes explained](https://www.youtube.com/watch?v=0swOh5C3OVM) 
 PV <-> PVC <-> Storage class  
 [[Techworld with Nana](https://www.youtube.com/channel/UCdngmbVKX1Tgre699-XLlUA)]   
 - [![](images/ico/color/youtube_16.png) ![](images/ico/terminal_16.png) 27:28 Dynamically provision NFS persistent volumes in Kubernetes](https://www.youtube.com/watch?v=AavnQzWDTEk)  
 [[Just me and Opensource](https://www.youtube.com/channel/UC6VkhPuCCwR_kG0GExjoozg)] 
