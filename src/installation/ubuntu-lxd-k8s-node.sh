#!/bin/bash

#
# This is a scripted version of https://github.com/justmeandopensource/kubernetes/blob/master/docs/install-cluster-ubuntu-20.md
# Execute as root within a worker or master node
#

# Disable firewall
ufw disable

# Disable swap
swapoff -a; sed -i '/swap/d' /etc/fstab

# Update sysctl settings for Kubernetes networking
# These settings surprise me see https://wiki.libvirt.org/page/Net.bridge.bridge-nf-call_and_sysctl.conf
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Install docker engine
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y docker-ce=5:19.03.10~3-0~ubuntu-focal containerd.io

# Kubernetes setup
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes components
apt update && apt install -y kubeadm=1.19.2-00 kubelet=1.19.2-00 kubectl=1.19.2-00

# Hack required to provision K8s v1.15+ in LXC containers
# Still needed ? /dev/kmsg exists nowadays (Ubuntu 20.04) in containers.
# Perhaps checking existance first ?
# Anyway - will only work if the containers (profile) security policy is set to priviledged
# security.privileged: "true"
mknod /dev/kmsg c 1 11
echo '#!/bin/sh -e' >> /etc/rc.local
echo 'mknod /dev/kmsg c 1 11' >> /etc/rc.local
chmod +x /etc/rc.local
