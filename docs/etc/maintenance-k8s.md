
# Helpers
```
kubectl apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml
```

Holding snaps forever
```
snap refresh --hold=forever
```

# Invalid certificates
Trouble with invalid certificates when executing ``kubectl logs`` and ``kubectl exec`` for kubelets from version ~1.30 ?
see https://github.com/canonical/microk8s/issues/4522  
see also https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/

This advice seemed to help (with restart and delay however)  
``the line "--kubelet-certificate-authority=${SNAP_DATA}/certs/ca.crt" can be removed from "/var/snap/microk8s/current/args/kube-apiserver"``

kube-apiserver args as a reference:
```bash
root@homekube:/var/snap/microk8s/current/args# cat kube-apiserver
--cert-dir=${SNAP_DATA}/certs
--service-cluster-ip-range=10.152.183.0/24
--authorization-mode=RBAC,Node
--service-account-key-file=${SNAP_DATA}/certs/serviceaccount.key
--client-ca-file=${SNAP_DATA}/certs/ca.crt
--tls-cert-file=${SNAP_DATA}/certs/server.crt
--tls-private-key-file=${SNAP_DATA}/certs/server.key
--tls-cipher-suites=TLS_AES_128_GCM_SHA256,TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256,TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256,TLS_RSA_WITH_3DES_EDE_CBC_SHA,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_256_GCM_SHA384
--kubelet-client-certificate=${SNAP_DATA}/certs/apiserver-kubelet-client.crt
--kubelet-client-key=${SNAP_DATA}/certs/apiserver-kubelet-client.key
--secure-port=16443
--etcd-servers="unix://${SNAP_DATA}/var/kubernetes/backend/kine.sock:12379"
--allow-privileged=true
--service-account-issuer='https://kubernetes.default.svc'
--service-account-signing-key-file=${SNAP_DATA}/certs/serviceaccount.key
--event-ttl=5m
--profiling=false

# Enable the aggregation layer
--requestheader-client-ca-file=${SNAP_DATA}/certs/front-proxy-ca.crt
--requestheader-allowed-names=front-proxy-client
--requestheader-extra-headers-prefix=X-Remote-Extra-
--requestheader-group-headers=X-Remote-Group
--requestheader-username-headers=X-Remote-User
--proxy-client-cert-file=${SNAP_DATA}/certs/front-proxy-client.crt
--proxy-client-key-file=${SNAP_DATA}/certs/front-proxy-client.key
#~Enable the aggregation layer
--enable-admission-plugins=EventRateLimit
--admission-control-config-file=${SNAP_DATA}/args/admission-control-config-file.yaml

# disbled this for hopefully solving the kubectl exec and kubectl logs certificate errors - aha
# see https://github.com/canonical/microk8s/issues/4522
#--kubelet-certificate-authority=${SNAP_DATA}/certs/ca.crt
--kubelet-preferred-address-types=InternalIP,Hostname,InternalDNS,ExternalDNS,ExternalIP

# oidc
--oidc-issuer-url=https://keycloak.auth.homekube.org/realms/homekube
--oidc-client-id=homekube-client
--oidc-username-claim=email
--oidc-groups-claim=groups
```