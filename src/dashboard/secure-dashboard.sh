#!/bin/bash
if [ -z "${HOMEKUBE_USER_NAME}" ]
then
  echo "HOMEKUBE_USER_NAME variable is not set. Assuming 'simple-user'".
  HOMEKUBE_USER_NAME=simple-user
fi
echo "Read the authentication token for user ${HOMEKUBE_USER_NAME}"
HOMEKUBE_NAMESPACE=kubernetes-dashboard
token=$(microk8s.kubectl -n ${HOMEKUBE_NAMESPACE} get secret | grep ${HOMEKUBE_USER_NAME}-token | cut -d " " -f1)
if [ -z "$token" ]
then
  echo "User ${HOMEKUBE_USER_NAME} not found. Probably you need to create the user first. See the 'create-admin-user.yaml'"
  exit 1
fi
HOMEKUBE_DASHBOARD_TOKEN=$(microk8s.kubectl -n ${HOMEKUBE_NAMESPACE} get secret $token -o jsonpath='{.data.token}' | base64 -d)
envsubst < ingress-dashboard-auth.yaml | kubectl apply -f -
