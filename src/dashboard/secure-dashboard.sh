#!/bin/bash
echo "Read the authentication token for user ${HOMEKUBE_USER_NAME}"
HOMEKUBE_NAMESPACE=kubernetes-dashboard
token=$(microk8s.kubectl -n ${HOMEKUBE_NAMESPACE} get secret | grep ${HOMEKUBE_USER_NAME}-token | cut -d " " -f1)
if [ -z "$token" ]
then
  echo "User ${HOMEKUBE_USER_NAME} not found. Probably you need to create the user first. See the 'create-admin-user.yaml'"
  exit 1
fi
HOMEKUBE_DASHBOARD_TOKEN=$(microk8s.kubectl -n ${HOMEKUBE_NAMESPACE} get secret $token -o jsonpath='{.data.token}' | base64 -d)
cp ingress-dashboard-auth.yaml temp.yaml
# replace the token with the env var
sed -i 's|${HOMEKUBE_DASHBOARD_TOKEN}|'${HOMEKUBE_DASHBOARD_TOKEN}'|' temp.yaml
kubectl apply -f temp.yaml
rm temp.yaml
