#!/bin/bash

# environment variables must have been set before executing the script !
#set -a
#. ./homekube.env.sh
#set +a
#
# Usage: bash -i install-all.sh



# source helper functions
. ./helpers.sh

# check if specified persistent storage exists or can be mounted
checkmount
if [[$? -ne 0]]; then
  exit 1
fi

# start installation
apt update
echo "Waiting for Microk8s ready state"
microk8s status --wait-ready
microk8s kubectl version
microk8s enable rbac
microk8s enable metallb:${HOMEKUBE_PUBLIC_IPS}

INSTALL_DIR=$(pwd)

cd ${INSTALL_DIR}/whoami
. ./install.sh
cd ${INSTALL_DIR}/ingress
. ./install.sh
cd ${INSTALL_DIR}/dashboard
. ./install.sh
cd ${INSTALL_DIR}/storage/nfs
. ./install.sh
cd ${INSTALL_DIR}/prometheus
. ./install.sh
cd ${INSTALL_DIR}/grafana
. ./install.sh
cd ${INSTALL_DIR}

echo "Next steps: Installation of cert-manager"
echo "Cert manager automates creation and renewal of LetsEncrypt certificates"
echo "Follow docs/cert-manager.md"
