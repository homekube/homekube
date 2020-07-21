# Basic installation

## Requirements

Further its assumed that your server is a separate computer. It might be a VM as well but thats beyond the scope of these instructions.
For the purpose of this tutorial it is assumed that

1) Your homenet is in the portrange `192.168.1.0 - 192.168.1.255` (A class C subnet 192.168.1.0/24) 
2) Your servers ip is static `192.168.1.100` and the username is `mykube`
3) You have a free range of unassigned ips that are excluded from your routers dhcp address range.
We will use these addresses to substitute the functionality of a cloud providers LoadBalancer for all your incoming traffic.
These addresses may not be used by any other device in your network. Here we assume this (randomly chosen) 
portrange is 
`192.168.1.200-192.168.1.220`  
You'll need a minimum of 5 IPs but its better to have some headroom for extensions and your own exercises. 

Of course you can choose whatever is appropriate for your environment as long as you modify the commands accordingly.
  
Open a terminal on your computer and connect to your server 
```bash
ssh mykube@192.168.1.100
```

Its recommended to fork the repo on github and clone your fork to your server.
This way you might save all your local changes or additions to your own repo and if you notice errors
or suggest improvements you might easily sumbit a PR to improve homekube. 

```bash
# Recommended
git clone git@github.com:<your clone>/homekube.git

# Alternative
git clone git@github.com:a-hahn/homekube.git
```

---
Then follow the [![](images/ico/color/ubuntu_16.png) **steps 1-3** in the Microk8s tutorial](https://microk8s.io/docs).
At this point you are done with a base installation and this tutorial will lead you through the next steps of installing the other apps.

## Installation

```bash
sudo snap install microk8s --classic --channel=1.18/stable
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
su - $USER
microk8s status --wait-ready
```
Add an alias for `kubectl` to reduce our typing by appending `~/.bash_aliases` with  
`alias kubectl='microk8s kubectl'`  
and activate it instantly `. ~/.bash_aliases`

---
Finally in your terminal window execute

```bash
kubectl version --short
```

The response will be something like
```
Client Version: v1.18.2-41+b5cdb79a4060a3   
Server Version: v1.18.2-41+b5cdb79a4060a3
```
Congrats ! You are done with the first part.

## Enable Add-Ons

Next we will enable a couple of add-ons. The MicroK8s tutorial lists a [![](images/ico/color/ubuntu_16.png) couple of add-ons](https://microk8s.io/docs/addons)
but explanations are rather short and we will only install basic components so that the setup comes close to a base cloud setup.

```bash
microk8s enable dns storage rbac helm3
```
More ![](images/ico/color/homekube_16.png)[  about AddOns ...](docs/microk8s-addons.md) 

## Next steps

Lets proceed installing the ![](images/ico/color/homekube_16.png)[  kubernetes dashboard](docs/dashboard.md)    
  

