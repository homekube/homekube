# Authentication with Keycloak

Keycloak authentication allows true oidc2 auth for the dashboard for managing various access rights
(Demo user, Admin user, ...)

## Preparation

Requirements:

- ![](images/ico/color/homekube_16.png)[ Keycloak installation](keycloak-installation.md)
- ![](images/ico/color/homekube_16.png)[ Keycloak configuration](keycloak-configuration.md)

## Tasks

### Kube-Apiserver
The kube-apiserver needs to be configured to accept authorizations through the oidc provider

Append these lines to ``/var/snap/microk8s/current/args/kube-apiserver`` and then restart.  
``microk8s stop`` and ``microk8s start``.  
See https://kubernetes.io/docs/reference/access-authn-authz/authentication/#configuring-the-api-server
```
# oidc config to append the kube-apiserver config
# /var/snap/microk8s/current/args/kube-apiserver

# edit domain of your auth server, for example auth.sso.homekube.org 
--oidc-issuer-url=https://keycloak.auth.homekube.org/realms/homekube
--oidc-client-id=homekube-client
--oidc-username-claim=email
--oidc-groups-claim=groups

```

See also https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens

Possibly also the local kubeconfig needs modification
https://devopscube.com/kubernetes-kubeconfig-file/

### Test with access tokens

The ``microk8s kubectl`` uses the configuration from ``~/.kube/config`` and does not accept ``--token=some_id_token`` parameters in its default configuration.
Install an unmodified version of kubectl via snap, e.g. ``snap install kubectl --classic``.  
This version can then be parametrized.
It can be installed for **remote access to your cluster** on any workstation anywhere provided it is accessible from your local network. See also https://microk8s.io/docs/working-with-kubectl  
Then retrieve the **access token** from the keycloak server:
```
curl -X POST https://keycloak.auth.homekube.org/realms/homekube/protocol/openid-connect/token \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "username=auth-user" \
-d "password=auth-password" \
-d "grant_type=password" \
-d "client_secret=<client-secret-as-generated-by-keycloak>" \
-d "client_id=homekube-client"
```

You can inspect tokens online on https://jwt.io/
See also https://gatillos.com/yay/2022/10/02/blog-how-do-tokens-work-in-Kubernetes.html

Note: If curl does not exist you might use e.g.
```
kubectl run -it --rm --image=curlimages/curl curly -- sh
```

When everything is setup properly you can access the dashboard https://dashboard.auth.homekube.org/#/pod?namespace=_all


## Resources and links

### Logging out

For session cleanup you need to invalidate the session and clear oauth2 cookies.
 
### TODO Update links
```
# invalidate session 
https://keycloak.auth.homekube.org/realms/homekube/protocol/openid-connect/logout

# clear oauth2 cookies
https://dashboard.auth.homekube.org/oauth2/sign_out
https://whoami.auth.homekube.org/oauth2/sign_out

# In one (With url encoded parrms)
https://dashboard.auth.homekube.org/oauth2/sign_out?rd=https%3A%2F%2Fkeycloak.auth.homekube.org%2Frealms%2Fhomekube%2Fprotocol%2Fopenid-connect%2Flogout
https://whoami.auth.homekube.org/oauth2/sign_out?rd=https%3A%2F%2Fkeycloak.auth.homekube.org%2Frealms%2Fhomekube%2Fprotocol%2Fopenid-connect%2Flogout
```

https://www.enricobassetti.it/2021/04/protect-kubernetes-dashboard-using-oauth2-proxy-and-keycloak/
https://stackoverflow.com/questions/70584157/unable-to-load-kubernetes-dashboard-after-successful-oauth2
https://itnext.io/protect-kubernetes-dashboard-with-openid-connect-104b9e75e39c
https://www.talkingquickly.co.uk/webapp-authentication-keycloak-OAuth2-proxy-nginx-ingress-kubernetes
https://blog.heptio.com/on-securing-the-kubernetes-dashboard-16b09b1b7aca  
https://github.com/oauth2-proxy/oauth2-proxy/issues/1213  
https://www.lakshminp.com/microk8s-oidc/  
https://medium.com/elmo-software/kubernetes-authenticating-to-your-cluster-using-keycloak-eba81710f49b  
https://medium.com/@charled.breteche/kind-keycloak-securing-kubernetes-api-server-with-oidc-371c5faef902  


https://www.keycloak.org/docs/latest/authorization_services/index.html  
https://kubernetes.io/docs/reference/access-authn-authz/rbac/#kubectl-auth-reconcile  

https://github.com/oauth2-proxy/oauth2-proxy  
https://oauth2-proxy.github.io/oauth2-proxy/docs/features/endpoints/  
https://oauth2-proxy.github.io/oauth2-proxy/docs/configuration/overview/  
https://github.com/kubernetes/ingress-nginx/tree/main  

https://keycloak.auth.homekube.org/realms/homekube/.well-known/openid-configuration

https://quay.io/repository/oauth2-proxy/oauth2-proxy?tab=tags&tag=latest

https://usmanshahid.medium.com/levels-of-access-control-through-keycloak-part-3a-integration-with-kubernetes-2568ad2055d4
https://middlewaretechnologies.in/2022/01/how-to-protect-the-kuberentes-dashboard-using-keycloak-oidc-and-oauth2-proxy.html
https://middlewaretechnologies.in/2022/01/how-to-authenticate-user-with-keycloak-oidc-provider-in-kubernetes.html
https://microk8s.io/docs/oidc-dex