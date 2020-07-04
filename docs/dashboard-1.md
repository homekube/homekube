# Dashboard - Improved

With minor changes to the Ingress dashboard configuration we can add http-basic-auth to our dashboard
so we get rid of the annoying token-lookup.

`cd ~/homekube/src/dashboard/`

and edit `ingress-dashboard-auth.yaml`.  

```bash
HOMEKUBE_USER_NAME=admin-user   # or: simple-user
source get-auth-token.sh        # script to retrieve the corresponding secret
kubectl -f ingress-dashboard-auth.yaml
```

- Authenticate through an authentication mockup service 
[![](images/ico/book_16.png) `https://httpbin.org/basic-auth/user/password`](https://httpbin.org) 
with credentials of your choice e.g. **demo/demo**
- Replace the Bearer token `eyJhbGciOiJSUzI1NiIsImt...aTBSzidQ` 
 in the **proxy_set_header** line with an [![](images/ico/color/homekube_16.png) access token](dashboard.md)  generated previously (for admin-user or simple-user).

After applying the changes

```bash
kubectl apply -f homekube-dashboard-auth.yaml
```

Open the dashboard in the **local browser `https://192.168.1.200`** and login with **demo/demo**  

You can revert to the previous version when applying the previous configuration

```bash
kubectl apply -f homekube-dashboard.yaml
```

## Next steps

Lets create our own automated LetsEncrypt certificates with
[![](images/ico/color/homekube_16.png) Cert-Manager](cert-manager.md). 
