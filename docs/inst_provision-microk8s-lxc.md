# MicroK8s Installation

## Installation

The final step is the installation of MicroK8s.
Its almost the same as we ![](images/ico/color/homekube_16.png)[ would do on the host](installation.md#installation).
See also [![](images/ico/color/ubuntu_16.png)Canonicals offical docs](https://microk8s.io/docs/lxd).

Step inside the container:

```
lxc exec microk8s -- bash
```

```bash
snap install microk8s --classic --channel=1.25/stable
```

## Fix AppArmor settings

These fixes are needed for the container to survive a reboot.
When the LXD container boots it needs to load the AppArmor profiles required by MicroK8s or else you may get the error:

``cannot change profile for the next exec call: No such file or directory``


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

`exit` the container and restart `lxc microk8s restart` it to activate the changes.  
Reenter the container `lxc exec microk8s -- bash` and verify the installation:

```bash
kubectl version --short
```

```text
Client Version: v1.25.4
Kustomize Version: v4.5.7
Server Version: v1.25.4
```

Now We are done with installation in a Microk8s container

## Further reading

[![](images/ico/book_16.png) ![](images/ico/color/ubuntu_16.png) Recommendations about using lxd](https://ubuntu.com/blog/lxd-5-easy-pieces)

## Troubleshooting

Error: [cannot change profile for the next exec call: No such file or directory](https://github.com/ubuntu/microk8s/issues/1643)

## Tutorials

- [![](images/ico/color/youtube_16.png) ![](images/ico/terminal_16.png) 48:03 Getting started with LXC containers](https://www.youtube.com/watch?v=CWmkSj_B-wo)  
  [[Just me and Opensource](https://www.youtube.com/channel/UC6VkhPuCCwR_kG0GExjoozg)] 
- [![](images/ico/color/youtube_16.png) ![](images/ico/terminal_16.png) 28:51 [ Kube 30 ] Deploying Kubernetes Cluster using LXC Containers](https://www.youtube.com/watch?v=XQvQUE7tAsk)  
  [[Just me and Opensource](https://www.youtube.com/channel/UC6VkhPuCCwR_kG0GExjoozg)] 

