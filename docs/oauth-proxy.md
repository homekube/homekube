# Authentication with Keycloak

Keycloak authentication allows true oidc2 auth for the dashboard for managing various access rights
(Demo user, Admin user, ...)

## Tasks

### Kube-Apiserver
The kube-apiserver needs to be configured to accept authorizations through the oidc provider

Add these lines to ``/var/snap/microk8s/current/args/kube-apiserver``

```
# OIDC (Keycloak)
--oidc-issuer-url=https://auth.oops.de/realms/test
--oidc-client-id=test-client
--oidc-groups-claim=groups
```

See also https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens

Possibly also the local kubeconfig needs modification
https://devopscube.com/kubernetes-kubeconfig-file/

### Test with access tokens

The ``microk8s kubectl`` uses the configuration from ``~/.kube/config`` and does not accept ``--token=some_id_token`` parameters in its default configuration.
Install an unmodified version of kubectl via snap, e.g. ``snap install kubectl --classic``. This version can then be parametrized.

Then retrieve the **access token** from the keycloak server:
```
curl -X POST https://auth.oops.de/realms/test/protocol/openid-connect/token \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "username=auth-user" \
-d "password=auth-password" \
-d "grant_type=password" \
-d "client_secret=iUxp1njMnX5iwfwwj4MLRKnT6KI80PHU" \
-d "client_id=test-client"
```

See also https://gatillos.com/yay/2022/10/02/blog-how-do-tokens-work-in-Kubernetes.html

Note: If curl does not exist you might use e.g.
```
kubectl run -it --rm --image=curlimages/curl curly -- sh
```
## Resources and links

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

https://auth.oops.de/realms/test/.well-known/openid-configuration

https://quay.io/repository/oauth2-proxy/oauth2-proxy?tab=tags&tag=latest