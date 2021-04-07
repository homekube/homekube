#!/bin/bash

# This script has been tested on Ubuntu 20.04
# Based on https://github.com/justmeandopensource/kubernetes/blob/master/lxd-provisioning/bootstrap-kube.sh
# The author Venkat does really GREAT !! tutorials
# Join his channel on youtube: https://www.youtube.com/channel/UC6VkhPuCCwR_kG0GExjoozg

echo "[PREFIX] Checking version"
echo "Latest version is $(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"
KUBE_VERSION="1.20.4-00"
echo "Installing version ${KUBE_VERSION}"

echo "[TASK 1] Install containerd runtime"
apt update
apt install -y containerd apt-transport-https
mkdir /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

# reference https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management
echo "[TASK 2] Add apt repo for kubernetes"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

echo "[TASK 3] Install Kubernetes components (kubeadm, kubelet and kubectl)"
apt install -y kubeadm="${KUBE_VERSION}" kubelet="${KUBE_VERSION}" kubectl="${KUBE_VERSION}"
# do we really need this ? => echo 'KUBELET_EXTRA_ARGS="--fail-swap-on=false"' > /etc/default/kubelet
systemctl restart kubelet

echo "[TASK 4] Fixes for arm64/Raspberry Pi on Ubuntu 20.04 systems"
# Hack (mknod /dev/kmsg c 1 11) required to provision K8s v1.15+ in LXC containers
# All the next commands are just needed to make sure that this hack survives a reboot
mknod /dev/kmsg c 1 11
cat > /etc/rc.local << EOF
#!/bin/sh -e
mknod /dev/kmsg c 1 11
EOF
chmod +x /etc/rc.local

# Hack required to allow for and enable rc.local (at least on ubuntu 20.04)
# see https://www.linuxbabe.com/linux-server/how-to-enable-etcrc-local-with-systemd
cat > /etc/systemd/system/rc-local.service << EOF
[Unit]
 Description=/etc/rc.local Compatibility
 ConditionPathExists=/etc/rc.local

[Service]
 Type=forking
 ExecStart=/etc/rc.local start
 TimeoutSec=0
 StandardOutput=tty
 RemainAfterExit=yes
 SysVStartPriority=99

[Install]
 WantedBy=multi-user.target
EOF
systemctl enable rc-local
