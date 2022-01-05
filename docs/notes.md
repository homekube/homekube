# Copying secrets

Example :

```
kubectl get secret gitlab-registry --namespace=revsys-com --export -o yaml |\
   kubectl apply --namespace=devspectrum-dev -f -
```
