# Overview of installation variants

from simple to sophisticated

## Single host

| | Single node | Clustered |
|---|-------------|-----------|
| | ![](../images/scans/1-Single-Host-unclustered.jpg)| ![](../images/scans/2-Single-Host-Multi-Cluster.jpg)|
| + | Simple installation | 2 or more independent clusters possible |
| - | Limited options | Requires containers / VMs |
| | [![](../images/ico/color/youtube_16.png) ![](../images/ico/terminal_16.png) 25:24 Basic single node installation of kubernetes on Raspberry Pi](https://www.youtube.com/watch?v=Gir3XTeIzFk) | [![](images/ico/color/youtube_16.png) ![](images/ico/terminal_16.png) 42:21 Installing a kubernetes cluster on Raspberry Pi](https://www.youtube.com/watch?v=G91wlOAsW00)  |


[![](../images/ico/color/youtube_16.png) ![](../images/ico/terminal_16.png) 23:07 Verify your installation using the dashboard and a simple helm chart](https://www.youtube.com/watch?v=1I97auLOarg)

## Multiple hosts

| | Single Cluster | Multi Clustered |
|---|-------------|-----------|
| | ![](../images/scans/3-Multi-Host-Single-Cluster.jpg)| ![](../images/scans/4-Multi-Host-Multi-Cluster.jpg)|
| + | <ul><li>Medium complex installation</li><li>Requires setup of bridges but its similar to single host</li></ul>  | Most efficient use of hardware  |
| - | Not the most efficient use of hardware | Requires bridges + containers / VMs |
|  |  Just repeat the installation steps for a single host | [![](../images/ico/color/youtube_16.png) ![](../images/ico/terminal_16.png) 27:45 More Raspberries - more challenges. Install a multi host - multi cluster Raspberry Pi 'farm'](https://www.youtube.com/watch?v=VI9YGBLEEew)  |

Note that these variants are not maintained in detail and might change frequently.

# Chosing a variant

Microk8s based variants are pretty detailed and usually well documented on Canonicals project page.

LXC based installations are better than a 'plain' installation of microk8s as they allow multiple independent installations (e.g. clusters)
on a single host. However they require a more sophisticated setup.

| | Homekube docs | Canonical docs (Microk8s) |
|---|-------------|-----------|
| | [![](../images/ico/color/homekube_16.png) LXC installation](./installation-lxc.md) | [![](../images/ico/color/ubuntu_16.png) LXC Installation](https://microk8s.io/docs/lxd)|
| | [![](../images/ico/color/homekube_16.png) LXC installation notes](./installation-lxd-notes.md) | [![](../images/ico/color/ubuntu_16.png) LXC Installation Upgrade](https://microk8s.io/docs/upgrade-cluster)|

