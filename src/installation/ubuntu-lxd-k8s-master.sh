#!/bin/bash

#
# This is a derived from https://github.com/justmeandopensource/kubernetes/blob/master/docs/install-cluster-ubuntu-20.md
# Execute as root within a master node
# Execute ubuntu-lxd-k8s-node.sh first
#

# change master ip
## kubeadm init --apiserver-advertise-address=172.16.16.100 --pod-network-cidr=192.168.0.0/16  --ignore-preflight-errors=all
#kubeadm init --apiserver-advertise-address=192.168.95.2 --pod-network-cidr=192.168.100.0/24  --ignore-preflight-errors=all
kubeadm init --pod-network-cidr=10.11.0.0/16  --ignore-preflight-errors=all

# Deploy Calico network
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

# Show cluster join command
kubeadm token create --print-join-command

