# Installation on a Raspberry 5

## Install cgroups
[Canonical Raspberry installation docs](https://microk8s.io/docs/install-raspberry-pi)
- Modify cgroups - this needs to be done
- Extra modules are not available docs is wrong
- Dont install microk8s - we will install lxc first

## Install Lxc containers
[Canonical LXD installation docs](https://microk8s.io/docs/install-lxd)
This doc is not completely accurate but read it in case of recent changes
[Use the Homekube doc](https://homekube.org/docs/inst_microk8s-lxc-macvlan.html)

In addition to canoncials docs we
- Switch off swapping (should be switched of by default but needs to be checked)
- Add the current user to LXD group e.g. ``sudo gpasswd -a $USER lxd``
- Install LXD (same as in canonicals docs)
- Create microk8s profile (same as in canonicals docs)
- Create a macvlan network profile (omitting this step leaves the container unreachable from external access)

## Install Microk8s and prepare Homekube

[Install microk8s and prepare Homekube](https://homekube.org/docs/inst_provision-microk8s-lxc.html)


