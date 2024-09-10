#!/bin/bash

if kubectl get ns | grep -q "^nfs-storage"; then
  echo "Skipping installation of nfs storage because namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns nfs-storage'"
  exit 1
fi

echo "Install nfs service (client needs existing server)"
sudo apt install nfs-common -y

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
kubectl create namespace nfs-storage

helm install nfs-client --version=4.0.17 \
  --set storageClass.name=managed-nfs-storage --set storageClass.defaultClass=true \
  --set nfs.server=${HOMEKUBE_NFS_SERVER_URL} \
  --set nfs.path=${HOMEKUBE_NFS_SERVER_PATH} \
  --set nfs.mountOptions={nfsvers=4} \
  --namespace nfs-storage \
  nfs-subdir-external-provisioner/nfs-subdir-external-provisioner
echo "Installation done nfs client"

