
# LXC commands

See [tutorial](https://techgoat.net/index.php?id=60)

## Copying containers

### From origin

```bash
lxc snapshot <container> snap01
lxc publish <container>/snap01 --alias web01Image
# create /home/ubuntu/web01Image.tar.gz in /home/ubuntu
lxc image export web01Image /home/ubuntu/web01Image
```

### To destination

```bash
lxc image import web01Image.tar.gz --alias homekube-auth
lxc init homekube-auth auth -p default -p microk8s -p macvlan
lxc exec auth -- bash

# After import we need to refresh certs - else we can't log or exec containers
# see https://microk8s.io/docs/command-reference#heading--microk8s-refresh-certs
cd /var/snap/microk8s/current/certs
microk8s refresh-certs -e ca.crt
snap restart microk8s
```
