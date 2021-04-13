```
lxc config device add <CONTAINER-NAME> install disk path=/root/install source=~/homekube/src/installation/k8s/lxc/node
lxc config device add <CONTAINER-NAME> homekube disk path=/root/homekube source=~/homekube/src/
```