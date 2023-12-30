# MicroK8s Installation

These steps need to be repeated for each container on the host

## Installation

This command installs and launches an empty OS Ubuntu 22.04 inside a container named ``homekube``
and applies 3 profiles in the order of specification. Later profile specs override earlier specs
so we can be sure that our macvlan network settings are honored:

```
lxc launch -p default -p microk8s -p macvlan ubuntu:22.04 homekube
```

Lets check if we were successful ``lxc list`` results in something like
```
+----------+---------+----------------------+------+-----------+-----------+
|   NAME   |  STATE  |         IPV4         | IPV6 |   TYPE    | SNAPSHOTS |
+----------+---------+----------------------+------+-----------+-----------+
| homekube | RUNNING | 192.168.1.101 (eth0) |      | CONTAINER | 0         |
+----------+---------+----------------------+------+-----------+-----------+
```

Note the IP V4 indicates that the container got an IP from DHCP service of our local network.
But always keep in mind that this container will not be reachable from the host.
Thats the limitation of macvlan networks. In case thats too limiting for you you need to install a bridge.
Read more [![](images/ico/book_16.png) about bridge configuration here](https://blog.simos.info/how-to-make-your-lxd-containers-get-ip-addresses-from-your-lan-using-a-bridge/)

Now we install ``microk8s`` inside a container named ``homekube`` and give it access to our cloned homekube repository on the host.

```bash
cd ~/homekube   # your fork of https://github.com/homekube/homekube.git
lxc config device add homekube homekube disk source=$(pwd) path=/root/homekube
lxc exec homekube -- bash
# Execute within container NOTE: If executed from host the self signed certificates will be based
# on the hosts ips and it will not be possible to step into pods
#
# NOTE !!! --channel=1.28/stable does NOT work on amd arch due to certificate failures when
# debugging containers (kubectl exec or kubectl logs) !!!
#
snap install microk8s --classic --channel=1.25/stable
microk8s status --wait-ready
microk8s enable rbac
```

**On the host** execute ``lxc list`` again and you should see something like.
Sidenote: You can step out of containers with the same command when leaving a shell: ``exit``

```bash
+----------+---------+----------------------------+------+-----------+-----------+
|   NAME   |  STATE  |            IPV4            | IPV6 |   TYPE    | SNAPSHOTS |
+----------+---------+----------------------------+------+-----------+-----------+
| homekube | RUNNING | 192.168.1.101 (eth0)       |      | CONTAINER | 0         |
|          |         | 10.1.74.128 (vxlan.calico) |      |           |           |
+----------+---------+----------------------------+------+-----------+-----------+
```

## Fix AppArmor settings

These fixes are needed for the container to survive a reboot.
When the LXD container boots it needs to load the AppArmor profiles required by MicroK8s or else you may get the error:

``cannot change profile for the next exec call: No such file or directory``

**Now step again into the container**

```bash
lxc exec homekube -- bash
```
and execute the next commands from inside the container

```bash
cat > /etc/rc.local <<EOF
#!/bin/bash

apparmor_parser --replace /var/lib/snapd/apparmor/profiles/snap.microk8s.*
exit 0
EOF
```

Make the rc.local executable:
```
chmod +x /etc/rc.local
```

## Fine tuning

On order to make all our existing scripts working out of the box we need
to apply the following changes once in the container:

Add aliases for ``kubectl`` and ``helm``
```bash
cat >> .bash_aliases << EOF
alias kubectl='microk8s kubectl'
alias helm='microk8s helm3'
EOF
```

## Reboot and enjoy

`exit` the container and restart `lxc restart homekube` it to activate the changes.  
Reenter the container `lxc exec homekube -- bash` and verify the installation:

```bash
kubectl version
```

```text
Client Version: v1.28.3
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Server Version: v1.28.3
```

Now We are done with installation in a Microk8s container

## Install Homekube appliances

### TLDR; Install all Homekube appliances in one go

```bash
lxc exec homekube -- bash
cd ~/homekube/src
# NOTE! edit env variables in install-all.sh to match your installation
bash -i install-all.sh
```

### Learn the individual steps and take the quick tour

Now proceed with the ![](../docs/images/ico/color/homekube_16.png) [ individual steps by taking the Quick tour](../Readme.md)


## Further reading

[![](images/ico/book_16.png) ![](images/ico/color/ubuntu_16.png) Recommendations about using lxd](https://ubuntu.com/blog/lxd-5-easy-pieces)

## Troubleshooting

Error: [cannot change profile for the next exec call: No such file or directory](https://github.com/ubuntu/microk8s/issues/1643)

## Tutorials

- [![](images/ico/color/youtube_16.png) ![](images/ico/terminal_16.png) 48:03 Getting started with LXC containers](https://www.youtube.com/watch?v=CWmkSj_B-wo)  
  [[Just me and Opensource](https://www.youtube.com/channel/UC6VkhPuCCwR_kG0GExjoozg)] 
- [![](images/ico/color/youtube_16.png) ![](images/ico/terminal_16.png) 28:51 [ Kube 30 ] Deploying Kubernetes Cluster using LXC Containers](https://www.youtube.com/watch?v=XQvQUE7tAsk)  
  [[Just me and Opensource](https://www.youtube.com/channel/UC6VkhPuCCwR_kG0GExjoozg)] 

