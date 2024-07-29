#!/bin/bash

# installation
# set -a
# . ./homekube.env.sh
# set +a

HOMEKUBE_PUBLIC_IPS=192.168.1.200-192.168.1.200 # public entry points for metallb load balancer
HOMEKUBE_DOMAIN=homekube.org  # the public domain of this site

# Settings for NFS server
HOMEKUBE_NFS_SERVER_URL=192.168.1.250  # The url of the nfs server
HOMEKUBE_NFS_SERVER_PATH=/Public/nfs/kubedata # The path to your data on the nfs server

# Settings for cert-manager
HOMEKUBE_DOMAIN_DASHED=${HOMEKUBE_DOMAIN//./-}  # required for cert-manager
HOMEKUBE_CERT_URL=https://auth.acme-dns.io # required for cert-manager

# Settings for SSO / Keycloak
HOMEKUBE_OIDC_ISSUER=https://auth.sso.homekube.org/realms/homekube
HOMEKUBE_OIDC_CLIENT_ID=homekube-client
HOMEKUBE_OAUTH2_CLIENT_SECRET=Lyzym6uI7dUYjyeKf40syWPnBH9IIOCI
HOMEKUBE_OAUTH2_COOKIE_SECRET=kgKUT3IMmESA81VWXvRpYIYwMSo1xndwIogUks6IS00=
