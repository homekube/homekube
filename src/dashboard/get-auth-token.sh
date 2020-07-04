#!/bin/bash
name=simple-user # or 'admin-user'
namespace=kubernetes-dashboard
token=$(kubectl -n $namespace get secret | grep ${name}-token | cut -d " " -f1)
echo $(kubectl -n $namespace get secret $token -o jsonpath='{.data.token}' | base64 -d)
