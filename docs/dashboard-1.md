# Dashboard - Improved

With minor changes to the Ingress dashboard configuration we can add http-basic-auth to our dashboard
so we get rid of the annoying token-lookup.

`cd ~/homekube/src/dashboard/`

## TL;DR run the script

```bash
HOMEKUBE_USER_NAME=admin-user   # or: simple-user
source get-auth-token.sh        # script to retrieve the corresponding secret
cp ingress-dashboard-auth.yaml temp.yaml
# replace the token with the env var
sed -i 's|${HOMEKUBE_DASHBOARD_TOKEN}|'${HOMEKUBE_DASHBOARD_TOKEN}'|' temp.yaml 
kubectl apply -f temp.yaml
rm temp.yaml
```

## Alternative: do it manually

and edit `ingress-dashboard-auth.yaml`.  

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  annotations:
    ingress.kubernetes.io/ssl-redirect: "true"
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/backend-protocol: HTTPS
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    # Calling a 3rd party basic-auth login that accepts logins with demo/demo credentials
    nginx.ingress.kubernetes.io/auth-url: https://httpbin.org/basic-auth/demo/demo
    # Configuration snippet sets "Authorization Bearer <bearer_token>
    nginx.ingress.kubernetes.io/configuration-snippet: |
      proxy_set_header "Authorization" "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InVZXzVvdmtBUnp4bmpaczdlVXdLWkhkU3U0QzZReTY1U3ZydlpNWTVqMjgifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJzaW1wbGUtdXNlci10b2tlbi1sYnRydyIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJzaW1wbGUtdXNlciIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImU4NWE5MTg2LTE1ZjMtNGUwNi05N2ExLTk1YTVkMjllYmE2ZiIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlcm5ldGVzLWRhc2hib2FyZDpzaW1wbGUtdXNlciJ9.dKF9MMGt1UxU8S78wcGYIA0BGDcvkOl-lyxqydy-1DwwWQ7Ao9yTMlQGyjMLppCTOJh7WyIe8CQ0_rB-tEnVaPALoOQK55kIAQf044pK6LDCQfuZm6PCFDY5VDuGgQX2xwK7JTveXCmy2JLf-LFQRYKusMxk86vNZFKpiIuGxpMlBrKsVECcXDQwLfsKvt9OonbGXR5_koGPceIGjYZxIo7TWutIpdhJCINLNEvpAZzvTPiFDr0PlasoNcBaUMjagZ65mG1AFciZQesaPmvykyGni_d-XXrXIEJQnmkOzclta7EBCry_0A5GMcWb-ORDEu1qhmmYQG4CZ4aTBSzidQ" ;
  name: ingress-dashboard-service
  namespace: kubernetes-dashboard
spec:
  rules:
    - http:
        paths:
          - backend:
              serviceName: kubernetes-dashboard
              servicePort: 443
            path: /


- Authenticate through an authentication mockup service 
[![](images/ico/book_16.png) `https://httpbin.org/basic-auth/user/password`](https://httpbin.org) 
with credentials of your choice e.g. **demo/demo**
- Replace the Bearer token `eyJhbGciOiJSUzI1NiIsImt...aTBSzidQ` 
 in the **proxy_set_header** line with an [![](images/ico/color/homekube_16.png) access token](dashboard.md)  generated previously (for admin-user or simple-user).

After applying the changes

```bash
kubectl apply -f homekube-dashboard-auth.yaml
```

## Check the result

Open the dashboard in the **local browser `https://192.168.1.200`** and login with **demo/demo**  

You can revert to the previous version when applying the previous configuration

```bash
kubectl apply -f homekube-dashboard.yaml
```

## Next steps

Lets create our own automated LetsEncrypt certificates with
[![](images/ico/color/homekube_16.png) Cert-Manager](cert-manager.md). 
