
# Installing Microk8s in LXC container using Macvlan

## Preparation host
Ubuntu default installations enable disk swapping.  
The kubernetes docs state explicitly that its an absolute requirement to
[![](images/ico/color/kubernetes_16.png) disable swapping](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin)
> You **MUST** disable swap in order for the kubelet to work properly

Thats easy to do
```
sudo swapoff -a
```
And make it permanent in ``/etc/fstab`` by uncommenting (prefixing with **#**) swap entries e.g.:
```
#/swap.img	none	swap	sw	0	0
```

## Preparation LXC container

Add your user to the lxd group.

```bash
sudo gpasswd -a $USER lxd
```
Activate this change by logging out and in again.

LXC launches containers using profiles and the first step is to create a default profile.  
Lets configure the host bridge as our default parent interface:

```bash
lxd init
```

All defaults should work properly. In case you are asked for a file system
on some systems **zfs** is the default answer.  
Use **dir** because most likely you have an ext4
file system as thats installed by default on Ubuntu.

```
Would you like to use LXD clustering? (yes/no) [default=no]:
Do you want to configure a new storage pool? (yes/no) [default=yes]: n
Would you like to connect to a MAAS server? (yes/no) [default=no]:
Would you like to create a new local network bridge? (yes/no) [default=yes]: n
Would you like to configure LXD to use an existing bridge or host interface? (yes/no) [default=no]:
Would you like the LXD server to be available over the network? (yes/no) [default=no]:
Would you like stale cached images to be updated automatically? (yes/no) [default=yes] n
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]:
```

## Prepare lxc container profiles

LXC Container profiles customize all kinds of resources such as
- memory allowance
- kernel modules
- security definitions
- disk folder mappings (container local path -> host filesystem)

### Default profile
A default profile is created upon ``lxd init`` which defines path mappings and basic networking.

### Microk8s profile
Next we will create a Mikrok8s profile that contains all the required configuration.
A template is prepared in our local source. You might want to check the 
[![](images/ico/color/ubuntu_16.png) ![](images/ico/github_16.png) original source](https://github.com/ubuntu/microk8s/blob/master/tests/lxc/microk8s.profile)
in case it was updated.

```
lxc profile create microk8s
cat ~/homekube/src/installation/k8s/lxc/host/microk8s-profile.yaml | lxc profile edit microk8s
```

Check the result ``lxc profile show microk8s``. It looks like
```
  boot.autostart: "true"
  linux.kernel_modules: ip_vs,ip_vs_rr,ip_vs_wrr,ip_vs_sh,ip_tables,ip6_tables,netlink_diag,nf_nat,overlay,br_netfilter
  raw.lxc: |
    lxc.apparmor.profile=unconfined
    lxc.mount.auto=proc:rw sys:rw cgroup:rw
    lxc.cgroup.devices.allow=a
    lxc.cap.drop=
  security.nesting: "true"
  security.privileged: "true"
description: ""
devices:
  aadisable:
    path: /sys/module/nf_conntrack/parameters/hashsize
    source: /sys/module/nf_conntrack/parameters/hashsize
    type: disk
  aadisable1:
    path: /sys/module/apparmor/parameters/enabled
    source: /dev/null
    type: disk
  aadisable2:
    path: /dev/kmsg
    source: /dev/kmsg
    type: disk
  aadisable3:
    path: /sys/fs/bpf
    source: /sys/fs/bpf
    type: disk
  aadisable4:
    path: /proc/sys/net/netfilter/nf_conntrack_max
    source: /proc/sys/net/netfilter/nf_conntrack_max
    type: disk
name: microk8s
used_by: []
```

### Network profile

As a last step in profile creation we will create a suitable network profile using Macvlan.
This configuration is simple. It will acquire ips from your local network and allow access to your containers from the network.
You can read [![](images/ico/book_16.png) background information here](https://blog.simos.info/how-to-make-your-lxd-container-get-ip-addresses-from-your-lan/)

First we need to find out our hosts primary network interface name: ``ip a s``. Result looks like:
```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp4s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether f0:79:59:5f:c1:5d brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.95/16 brd 192.168.255.255 scope global dynamic enp4s0
       valid_lft 62681sec preferred_lft 62681sec
    inet6 fe80::f279:59ff:fe5f:c15d/64 scope link 
       valid_lft forever preferred_lft forever
...
```
For macvlan creation you need to replace parent value **enp4s0** with your local settings:
```
lxc profile create macvlan
lxc profile device add macvlan eth0 nic nictype=macvlan parent=enp4s0
```
Check the result ``lxc profile show macvlan``. It looks like
```
config: {}
description: ""
devices:
  eth0:
    nictype: macvlan
    parent: enp4s0
    type: nic
name: macvlan
used_by: []
```

### Install an empty Ubuntu container

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

Now proceed with the ![](../docs/images/ico/color/homekube_16.png) [ installation of microk8s inside the container ](inst_provision-microk8s-lxc.md)
