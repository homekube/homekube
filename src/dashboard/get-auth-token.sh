#! /bin/bash
name=simple-user # or 'admin-user'
namespace=kubernetes-dashboard
token=$(microk8s.kubectl -n $namespace get secret | grep ${name}-token | cut -d " " -f1)
echo $(microk8s.kubectl -n $namespace get secret $token -o jsonpath='{.data.token}' | base64 -d)
