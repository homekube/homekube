#!/bin/bash

# environment variables must have been set before executing the script !
#set -a
#. ./homekube.env.sh
#set +a

# source helper functions
. ./helpers.sh

# check if specified persistent storage exists or can be mounted
checkmount
if [[$? -ne 0]]; then
  exit 1
fi

apt update
echo "Waiting for Microk8s ready state"
microk8s status --wait-ready
microk8s kubectl version
microk8s enable rbac
microk8s enable metallb:${HOMEKUBE_PUBLIC_IPS}

INSTALL_DIR=$(pwd)
cd ${INSTALL_DIR}/ingress
. ./install.sh
cd ${INSTALL_DIR}/storage/nfs
. ./install.sh
cd ${INSTALL_DIR}/postgres
. ./install.sh
cd ${INSTALL_DIR}/keycloak
. ./install.sh
cd ${INSTALL_DIR}

echo "Next steps: Configuration of Keycloak SSO. This needs to be done manually by "
echo "following the instructions Installation ${INSTALL_DIR}/../docs/keycloak-configuration.md"
echo "Then proceed with part 2 (install-with-sso-2.sh)"
