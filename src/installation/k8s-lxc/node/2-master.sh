#!/bin/bash

# Based on https://github.com/justmeandopensource/kubernetes/blob/master/lxd-provisioning/bootstrap-kube.sh
# Thank you !!

echo "Upgrade node to master"

echo "[TASK 1] Pull required containers"
kubeadm config images pull

echo "[TASK 2] Initialize Kubernetes Cluster"
kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=all

echo "[TASK 3] Copy kube admin config to root user .kube directory"
mkdir /root/.kube
cp /etc/kubernetes/admin.conf /root/.kube/config

echo "[TASK 4] Patching kube-proxy to fix crashloop (disable conntrack.maxPerCore) for Raspberry Pi /arm64"
kubectl get cm kube-proxy -n kube-system -o yaml > /tmp/kube-proxy.yaml
sed -i 's/maxPerCore: null/maxPerCore: 0/g' /tmp/kube-proxy.yaml
kubectl apply -f /tmp/kube-proxy.yaml
rm /tmp/kube-proxy.yaml

echo "[TASK 5] Deploy network"
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

echo "[TASK 6] Generate and save cluster join command to /root/joincluster.sh"
joinCommand=$(kubeadm token create --print-join-command 2>/dev/null)
echo "$joinCommand --ignore-preflight-errors=all" > /root/joincluster.sh
