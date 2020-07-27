# Troubleshooting

Monitoring Pods health e.g. during reboot / node startup /e.t.c.

```bash
kubectl get po -A --watch 
```

or namespaced

```bash
kubectl get po -n <namespace>
```

