# MicroK8s / Homekube Installation

In the previous step ![](images/ico/color/homekube_16.png)[we created the container](inst_microk8s-lxc-macvlan.md).

These steps need to be repeated for each Homekube container on the host

## Clone the github repo
Its recommended to fork the repo on github and clone your fork to your server.
This way you might save all your local changes or additions to your own repo and if you notice errors
or suggest improvements you might easily sumbit a PR to improve homekube.

```bash
# Recommended
git clone git@github.com:<your clone>/homekube.git

# Alternative
git clone https://github.com/homekube/homekube.git
```

Now we install ``microk8s`` inside a container named ``homekube`` and give it access to our cloned homekube repository on the host.

```bash
cd ~/homekube   # your fork of https://github.com/homekube/homekube.git
lxc config device add homekube homekube disk source=$(pwd) path=/root/homekube
lxc exec homekube -- bash

snap install microk8s --classic --channel=1.31/stable
microk8s status --wait-ready
microk8s enable dns rbac helm3
```

**On the host** execute ``lxc list`` again and you should see something like.
Sidenote: You can step out of containers with the same command when leaving a shell: ``exit``

```bash
+----------+---------+----------------------------+------+-----------+-----------+
|   NAME   |  STATE  |            IPV4            | IPV6 |   TYPE    | SNAPSHOTS |
+----------+---------+----------------------------+------+-----------+-----------+
| homekube | RUNNING | 192.168.1.100 (eth0)       |      | CONTAINER | 0         |
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
root@homekube:~# kubectl version
Client Version: v1.31.0
Kustomize Version: v5.4.2
Server Version: v1.31.0
```

Now We are done with installation in a Microk8s container

## Install Homekube appliances

### TLDR; Install all Homekube appliances in one go

```bash
lxc exec homekube -- bash
cd ~/homekube/src

# modify and set your environment variables !
set -a
. ./homekube.env.sh
set +a

echo "Please make sure that ${HOMEKUBE_NFS_SERVER_PATH} exists on ${HOMEKUBE_NFS_SERVER_URL} before proceeding with the installation !"
 
# Plain installation (without Keycloak SSO)
bash -i install-all.sh
# or install with Keycloak Single Sign On (more complex)
bash -i install-with-sso-1.sh
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
