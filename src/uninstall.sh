#!/bin/bash

if [[ $(kubectl get ns | grep -q "^$1") ]] ; then
  kubectl delete ns $1
  kubectl delete $1-pv
fi

if [[ $# -ne 1 ]]; then
  echo "Usage is: '. ./uninstall.sh <namespace> or . ./uninstall.sh all'"
  echo
fi

if [[ $1 -eq "all" ]]; then
  . ./uninstall.sh grafana
  . ./uninstall.sh ingress-nginx
  . ./uninstall.sh keycloak
  . ./uninstall.sh kubernetes-dashboard
  . ./uninstall.sh nfs-storage
  . ./uninstall.sh postgres
  . ./uninstall.sh prometheus
  . ./uninstall.sh whoami
fi

echo "List of namespaces: "
kubectl get ns

