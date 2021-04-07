# LXC/LXD installation

LXC containers have been around for years and while they don't provide the same level of isolation and security
as virtual machines they are a very resource efficient way to host a lot of containers on a small budget hardware.

It allows to test variants of the configuration and
it is also a preparation step to enhance the installation into a clustered multi-node and multi-host environment.

If you are new to lxc containers see the [![](images/ico/color/youtube_16.png) video tutorial section](#Tutorials) below first !

## Chosing the right network configuration

By default LXC containers install their own isolated bridge and cannot be reached from your local net.
Thats not very useful for most situations as it usually requires more individual configuration efforts later.

This table shows the configuration options for the different dataflows: 

| Source | Destination | Default | Macvlan | Host bridge | 
|------|----|---|----|----|
|Host| Any container| no| no | yes|
|Local network| Any container| no| yes | yes|
|Local network| Any container| no| yes | yes|
|Any container| Host| no| yes| yes|
|Any container| local network| no| yes| yes|
|Any container| Any container| yes| yes| yes|

> **IMPORTANT !!**
> There are certain restictions if your host is connected to a wireless network (e.g. notebook) or a virtual machine
> (VirtualBox or VmWare) This blogpost explains
[**reasons and options** and ![](images/ico/instructor_16.png) setup of a macvlan interface](https://blog.simos.info/how-to-make-your-lxd-container-get-ip-addresses-from-your-lan/)

For the sake of flexiblity the following instructions focus on network setup of a host bridge for unlimited
network access of all dataflows.

## Install a bridge on the host

The following commands are valid on Ubuntu **versions 18.04 and 20.04** which use
[![](images/ico/color/ubuntu_16.png) **netplan**](https://netplan.io) for defining its network. 
Lets create a bridge first.

> **Caution !!** Reconfiguring the network is potentially dangerous as you might lose your connection to the host.
> Make sure that you have **direct terminal access to the host** just in case !!

Check the network interfaces e.g. `ip a s` or `ls /sys/class/net -l` 
```text
lrwxrwxrwx 1 root root 0 Oct 12 12:57 enp0s10 -> ../../devices/pci0000:00/0000:00:0a.0/net/enp0s10
lrwxrwxrwx 1 root root 0 Oct 12 12:57 lo -> ../../devices/virtual/net/lo
```
In this example **enp0s10** is our primary interface (as its the only pci interface in the list).
Create a new network definition containing the bridge **br0** and replace **enp0s10** with the name of your
primary network interface.

```bash
# Enter sudo mode
sudo -i
``` 

```bash
cat > /etc/netplan/60-bridge-config-for-lxd-homekube.yaml << EOF
# This config will override the default to provide a host bridge
network:
    version: 2
    renderer: networkd
    ethernets:
        enp0s10:
            dhcp4: yes
    bridges:
      br0:
        dhcp4: yes
        interfaces: [enp0s10]
EOF

# activate bridge settings 
# CAUTION !! if you don't have physical access to the host !
netplan apply

# exit sudo mode
exit
```

Now running `ip a s` will show that there is a bridge named **br0** configured now:
```text
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s10: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master br0 state UP group default qlen 1000
    link/ether 00:26:2d:2d:2f:2f brd ff:ff:ff:ff:ff:ff
3: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:26:2d:2d:2f:2f brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.100/16 brd 192.168.255.255 scope global dynamic br0
       valid_lft 86255sec preferred_lft 86255sec
    inet6 fe80::f1:6bff:feb0:c558/64 scope link 
       valid_lft forever preferred_lft forever
5: vetha07ecbf1@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br0 state UP group default qlen 1000
    link/ether e2:72:93:2e:66:6b brd ff:ff:ff:ff:ff:ff link-netnsid 0
```

See also more [![](images/ico/color/ubuntu_16.png) Netplan configuration examples](https://netplan.io/examples) 

## Install lxc/lxd

LXD is an open source container management extension for Linux Containers (LXC). 
LXD both improves upon existing LXC features and provides a programming interface (REST API) to build and manage Linux containers.

In Ubuntu **18.04** and up lxc/lxd are already installed. Verify with `whereis lxc` and `whereis lxd`.
Add your username (mykube) to the lxd group so we don't need to run all the commands as 'sudo'.

```bash
sudo gpasswd -a mykube lxd
```

Activate this change by logging out and in again.

### Initialize lxd

LXC launches containers using profiles and the first step is to create a default profile.  
Lets configure the host bridge as our default parent interface:

```bash
lxd init
```

```
Would you like to use LXD clustering? (yes/no) [default=no]: n
Do you want to configure a new storage pool? (yes/no) [default=yes]: n
Would you like to connect to a MAAS server? (yes/no) [default=no]: 
Would you like to create a new local network bridge? (yes/no) [default=yes]: 
Would you like to configure LXD to use an existing bridge or host interface? (yes/no) [default=no]: y
Name of the existing bridge or host interface: br0
Would you like LXD to be available over the network? (yes/no) [default=no]: n
Would you like stale cached images to be updated automatically? (yes/no) [default=yes] 
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]: y
config: {}
networks: []
storage_pools: []
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      nictype: bridged
      parent: br0
      type: nic
  name: default
cluster: null
```

Lets verify the configuration:

```bash
lxc profile show default
```

```yaml
config: {}
description: Default LXD profile
devices:
  eth0:
    name: eth0
    nictype: bridged
    parent: br0
    type: nic
  root:
    path: /
    pool: default
    type: disk
name: default
```

## Create a kubernetes profile for lxc

LXC containers can't load kernel modules and we need to know in advance which kernel modules are required for successful execution
of a lxc container. This is quite a restriction as it can be sort of trial and error to find out proper settings.
For MicroK8s there is already a published 
[![](images/ico/color/ubuntu_16.png) ![](images/ico/github_16.png) MircoK8s profile](https://github.com/ubuntu/microk8s/blob/master/tests/lxc/microk8s.profile)
to use. Besides defining kernel modules it lowers security restrictions and defines apparmor settings

```
lxc profile create microk8s
EDITOR=nano lxc profile edit microk8s
```
Delete editor contents and copy the yaml from the above link and save its contents.

```yaml
name: microk8s
config:
  boot.autostart: "true"
  linux.kernel_modules: ip_vs,ip_vs_rr,ip_vs_wrr,ip_vs_sh,ip_tables,ip6_tables,netlink_diag,nf_nat,overlay,br_netfilter
  raw.lxc: |
    lxc.apparmor.profile=unconfined
    lxc.mount.auto=proc:rw sys:rw cgroup:rw
    lxc.cgroup.devices.allow=a
    lxc.cap.drop=
  security.nesting: "true"
  security.privileged: "true"
description: "Official Ubuntu Microk8s LXC profile from their repo"
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
```

Check the profile

```bash
lxc profile list
```

```text
+-----------+---------+
|   NAME    | USED BY |
+-----------+---------+
| default   | 0       |
+-----------+---------+
| microk8s  | 0       |
+-----------+---------+
```

```bash
lxc profile show microk8s
```

This will show the profiles contents

## Launch MicroK8s container

The next step is launching the container based on the predefined settings.
Note that we need to specify both profiles for the settings of MicroK8s and our network configuration.

```bash
lxc launch ubuntu:20.04 microk8s -p microk8s -p default
```

```text
Creating microk8s
Starting microk8s                         
```

```bash
lxc list
```

```text
+----------+---------+----------------------------+------+-----------+-----------+
|   NAME   |  STATE  |            IPV4            | IPV6 |   TYPE    | SNAPSHOTS |
+----------+---------+----------------------------+------+-----------+-----------+
| microk8s | RUNNING | 192.168.1.120 (eth0)       |      | CONTAINER | 0         |
+----------+---------+----------------------------+------+-----------+-----------+
```
Now we have created an empty Ubuntu 20.04 container named **microk8s** .
This container has been assigned the ip **192.168.1.120** from our networks dhcp service.
Now confirm with **ping 192.168.1.120** from other hosts in the network **and from your host**
that your container is fully accessible on the network.  

If its not pingable from your host the network bridge is not set up properly.

With `lxc stop microk8s` and `lxc start microk8s` we can start / stop the container.


## MicroK8s Installation

The final step is the installation of MicroK8s. 
Its almost the same as we [![](images/ico/color/homekube_16.png) would do on the host](installation.md#installation).  
Step inside the container:

```
lxc exec microk8s -- bash
```

```bash
sudo snap install microk8s --classic --channel=1.19
```

```bash
cat >> .bashrc << EOF
#
# Add alias for kubectl
alias kubectl='microk8s kubectl'
EOF
```

`exit` the container and restart `lxc microk8s restart` it to activate the changes.  
Reenter the container `lxc exec microk8s -- bash` and verify the installation:

```bash
kubectl version --short
```

```text
Client Version: v1.19.2-34+1b3fa60b402c1c
Server Version: v1.19.2-34+1b3fa60b402c1c
```

Now We are done with installation in a Microk8s container

## Troubleshooting

Error: [cannot change profile for the next exec call: No such file or directory](https://github.com/ubuntu/microk8s/issues/1643)

## Tutorials

 - [![](images/ico/color/youtube_16.png) ![](images/ico/terminal_16.png) 48:03 Getting started with LXC containers](https://www.youtube.com/watch?v=CWmkSj_B-wo)  
 [[Just me and Opensource](https://www.youtube.com/channel/UC6VkhPuCCwR_kG0GExjoozg)] 
 - [![](images/ico/color/youtube_16.png) ![](images/ico/terminal_16.png) 28:51 [ Kube 30 ] Deploying Kubernetes Cluster using LXC Containers](https://www.youtube.com/watch?v=XQvQUE7tAsk)  
 [[Just me and Opensource](https://www.youtube.com/channel/UC6VkhPuCCwR_kG0GExjoozg)] 

