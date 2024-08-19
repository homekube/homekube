#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo "Usage is: '. ./uninstall.sh <namespace> or . ./uninstall.sh all'"
  echo
  echo "List of namespaces: "
  kubectl get ns
  exit 2
fi

if kubectl get ns | grep -q "^$1"; then
  kubectl delete ns $1
  if kubectl get pv | grep -q "^$1-pv" ; then
    kubectl delete pv $1-pv
  fi
fi

if [[ $1 == "all" ]]; then
  . ./uninstall.sh grafana
  . ./uninstall.sh ingress-nginx
  . ./uninstall.sh keycloak
  . ./uninstall.sh kubernetes-dashboard
  . ./uninstall.sh nfs-storage
  . ./uninstall.sh postgres
  . ./uninstall.sh prometheus
  . ./uninstall.sh whoami
fi
