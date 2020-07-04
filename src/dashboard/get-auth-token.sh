#! /bin/bash
echo "Read the authentication token for user ${HOMEKUBE_USER_NAME}"
HOMEKUBE_NAMESPACE=kubernetes-dashboard
token=$(microk8s.kubectl -n ${HOMEKUBE_NAMESPACE} get secret | grep ${HOMEKUBE_USER_NAME}-token | cut -d " " -f1)
HOMEKUBE_USER_TOKEN=$(microk8s.kubectl -n ${HOMEKUBE_NAMESPACE} get secret $token -o jsonpath='{.data.token}' | base64 -d)
