# Chosing a variant

from simple to sophisticated

## Single host

| | Single node | Clustered |
|---|-------------|-----------|
| | ![](images/scans/1-Single-Host-unclustered.jpg)| ![](images/scans/2-Single-Host-Multi-Cluster.jpg)|
| + | Simple installation | 2 or more independent clusters possible |
| - | Limited options | Requires containers / VMs |
| | [![](images/ico/color/youtube_16.png) ![](images/ico/terminal_16.png) 25:24 Basic single node installation of kubernetes on Raspberry Pi](https://www.youtube.com/watch?v=Gir3XTeIzFk) | [![](images/ico/color/youtube_16.png) ![](images/ico/terminal_16.png) 42:21 Installing a kubernetes cluster on Raspberry Pi](https://www.youtube.com/watch?v=G91wlOAsW00)  |


[![](images/ico/color/youtube_16.png) ![](images/ico/terminal_16.png) 23:07 Verify your installation using the dashboard and a simple helm chart](https://www.youtube.com/watch?v=1I97auLOarg)

## Multiple hosts

| | Single Cluster | Multi Clustered |
|---|-------------|-----------|
| | ![](images/scans/3-Multi-Host-Single-Cluster.jpg)| ![](images/scans/4-Multi-Host-Multi-Cluster.jpg)|
| + | <ul><li>Medium complex installation</li><li>Requires setup of bridges but its similar to single host</li></ul>  | Most efficient use of hardware  |
| - | Not the most efficient use of hardware | Requires bridges + containers / VMs |
|  |  Just repeat the installation steps for a single host | [![](images/ico/color/youtube_16.png) ![](images/ico/terminal_16.png) 27:45 More Raspberries - more challenges. Install a multi host - multi cluster Raspberry Pi 'farm'](https://www.youtube.com/watch?v=VI9YGBLEEew)  |

