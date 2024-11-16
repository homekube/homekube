# MicroK8s / Homekube Installation

In the previous step ![](images/ico/color/homekube_16.png)[we created the container](inst_microk8s-lxc-macvlan.md).

This documentation contains the provisioning steps for **Incus**. Incus is an alternative to and possibly a successor of **lxd** as the key developers
of lxd created a fork of lxd recently as a reaction of Canonicals licence change.
See also https://linuxcontainers.org/

## Install an empty Ubuntu container

This command installs and launches an empty OS Ubuntu 24.04 inside a container named ``homekube``
and applies 3 profiles in the order of specification. Later profile specs override earlier specs
so we can be sure that our macvlan network settings are honored:

```
apt install incus -y
incus launch -p default -p microk8s -p macvlan images:ubuntu/24.04/cloud homekube
```

Lets check if we were successful ``incus list`` results in something like
```
+----------+---------+----------------------+------+-----------+-----------+
|   NAME   |  STATE  |         IPV4         | IPV6 |   TYPE    | SNAPSHOTS |
+----------+---------+----------------------+------+-----------+-----------+
| homekube | RUNNING | 192.168.1.100 (eth0) |      | CONTAINER | 0         |
+----------+---------+----------------------+------+-----------+-----------+
```

Note the IP V4 indicates that the container got an IP from DHCP service of our local network.
But always keep in mind that this container will not be reachable from the host.
Thats the limitation of macvlan networks. In case thats too limiting for you you need to install a bridge.
Read more [![](images/ico/book_16.png) about bridge configuration here](https://blog.simos.info/how-to-make-your-lxd-containers-get-ip-addresses-from-your-lan-using-a-bridge/)

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
incus config device add homekube homekube disk source=$(pwd) path=/root/homekube
incus exec homekube -- bash

apt install snapd gettext-base nano -y   # needed for envsubst
exit # and reenter the container

incus exec homekube -- bash
snap install microk8s --classic --channel=1.31/stable
microk8s status --wait-ready
microk8s enable dns rbac helm3
```

**On the host** execute ``incus list`` again and you should see something like.
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
When the container boots it needs to load the AppArmor profiles required by MicroK8s or else you may get the error:

``cannot change profile for the next exec call: No such file or directory``

**Now step again into the container**

```bash
incus exec homekube -- bash
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

`exit` the container and restart `incus restart homekube` it to activate the changes.  
Reenter the container `incus exec homekube -- bash` and verify the installation:

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
incus exec homekube -- bash
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

