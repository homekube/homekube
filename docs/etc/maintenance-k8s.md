
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