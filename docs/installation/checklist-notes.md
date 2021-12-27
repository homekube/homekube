
sudo swapoff -a
Create a bridge or macvlan for lxc
bridge: https://blog.simos.info/how-to-make-your-lxd-containers-get-ip-addresses-from-your-lan-using-a-bridge/
macvlan: https://blog.simos.info/how-to-make-your-lxd-container-get-ip-addresses-from-your-lan/

lxc profile device add macvlan eth0 nic nictype=macvlan parent=name_of_parent_if
network: lxc profile add homekube macvlan
AppArmor script for lxc
bash_aliases before installing cluster
