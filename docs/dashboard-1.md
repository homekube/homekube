# Dashboard - Improved

With minor changes to the Ingress dashboard configuration we can add http-basic-auth to our dashboard
so we get rid of the annoying token-lookup.

`cd ~/homekube/src/dashboard/`

## TL;DR 

Execute commands for automated upgrade: 

```bash
HOMEKUBE_USER_NAME=admin-user   # or: simple-user
./secure-dashboard.sh
```

## Alternative: do it manually

- Find the [![](images/ico/color/homekube_16.png) access token](dashboard.md)
  generated previously (for admin-user or simple-user) and copy it to the clipboard.
- Paste into an environment variable `HOMEKUBE_DASHBOARD_TOKEN=<your_pasted_token>`
- Authentication is performed through an authentication mockup service 
[![](images/ico/book_16.png) `https://httpbin.org/basic-auth/user/password`](https://httpbin.org) 
default is **demo/demo**  
Modify `homekube-dashboard-auth.yaml` with credentials of your choice 

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
