#!/bin/bash

# installation
# set -a
# . ./homekube.env.sh
# set +a

HOMEKUBE_PUBLIC_IPS=192.168.1.200-192.168.1.200 # public entry points for metallb load balancer
HOMEKUBE_DOMAIN=homekube.org  # the public domain of this site
HOMEKUBE_DOMAIN_DASHED=${HOMEKUBE_DOMAIN//./-}  # required for cert-manager
HOMEKUBE_CERT_URL=https://auth.acme-dns.io # required for cert-manager
HOMEKUBE_NFS_SERVER_URL=192.168.1.250  # The url of the nfs server
HOMEKUBE_NFS_SERVER_PATH=/Public/nfs/kubedata # The path to your data on the nfs server
