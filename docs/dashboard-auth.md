# Dashboard - Improved

With minor changes to the Ingress dashboard configuration we can add http-basic-auth to our dashboard
so we get rid of the annoying token-lookup.

`cd ~/homekube/src/dashboard/`

## TL;DR 

Execute commands for automated upgrade: 

```bash
HOMEKUBE_USER_NAME=admin-user   # or: simple-user for public access
source secure-dashboard.sh
```

**NOTE !** If your dashboard is publicly accessible you better use the `simple-user`.

## Alternative: do it manually

- Copy `homekube-dashboard-auth.yaml` to `temp.yaml`
- Find the ![](images/ico/color/homekube_16.png)[ access token](dashboard.md)
  generated previously (for admin-user or simple-user) and copy it to the clipboard.
- Replace the environment variable `${HOMEKUBE_DASHBOARD_TOKEN}` with the copied value.
- Authentication is performed through an authentication mockup service 
[![](images/ico/book_16.png) `https://httpbin.org/basic-auth/user/password`](https://httpbin.org) 
default credentials are **demo/demo**  
Modify `temp.yaml` with credentials of your choice
- Apply changes `kubectl apply -f temp.yaml` and remove the file `rm temp.yaml`

## Check the result

Open the dashboard in the **local browser `https://192.168.1.200`** and login with **demo/demo**  

You can revert to the previous version when applying the previous configuration

```bash
kubectl apply -f ingress-dashboard.yaml
```

## Public Exposure

Optionally deploy the Dashboard to the public. We do it here for the purpose of demonstration but of course 
in general thats not recommended for security reasons.

In `ingress-dashboard-auth.yaml` uncomment the host part to contain a `host: dashboard.homekube.org` property:

```yaml
spec:
  rules:
    - host: dashboard.homekube.org
      http:
        paths:        
```
then reapply the commands above:
```bash
HOMEKUBE_USER_NAME=simple-user
source secure-dashboard.sh
```

Now access 
[![](images/ico/color/homekube_link_16.png) https://dashboard.homekube.org](https://dashboard.homekube.org) 
using **demo/demo** credentials.

## Next steps

Lets create our own automated LetsEncrypt certificates with
![](images/ico/color/homekube_16.png)[ Cert-Manager](cert-manager.md). 
