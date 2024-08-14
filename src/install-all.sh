#!/bin/bash

set -a
. ./homekube.env.sh
set +a

apt update
echo "Waiting for Microk8s ready state"
microk8s status --wait-ready
microk8s kubectl version
microk8s enable rbac
microk8s enable metallb:${HOMEKUBE_PUBLIC_IPS}

. ./whoami/install.sh
. ./ingress/install.sh
. ./dashboard/install.sh
. ./storage/nfs/install.sh
. ./prometheus/install.sh
. ./grafana/install.sh

echo "Next steps: Installation of cert-manager"
echo "Cert manager automates creation and renewal of LetsEncrypt certificates"
echo "Follow docs/cert-manager.md"
