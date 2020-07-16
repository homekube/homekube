# Notes

Grafanas helm chart offer so many configuration options and its not easy to keep track of.
Many options exclude each other and it is not immediately obvious.

For a deeper dive the helm charts
[![](images/ico/github_16.png) values.yaml](https://github.com/helm/charts/blob/master/stable/grafana/values.yaml)
is a highly recommended read. As with all helm charts this chart is installed by default before all other
customizations are installed.

Depending on the installation settings this chart also deploys `sidecars` e.g. helper containers that are responsible
for downloading dashboards.

Here are some installation snippets for the record which support installation of dashboards with a **ConfigMap**.
However this incompatible with configuring installation of dashboards from the grafana website in the same 
installation script. (`dashboards` - section in `datasource-dashboards.yaml` must be omitted [as in `values.yaml`]) 

```bash
# works only with 
# -- set sidecar.dashboards.enabled=true

#kubectl -n grafana create cm grafana-dashboard-nginx-performance --from-file=dashboards/nginx-request-handling-performance-2m.json
#kubectl -n grafana label cm grafana-dashboard-nginx-performance grafana_dashboard=nginx-performance

#kubectl -n grafana create cm grafana-dashboard-nginx --from-file=https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/grafana/dashboards/nginx.json
#kubectl -n grafana label cm grafana-dashboard-nginx grafana_dashboard=nginx

```

## Troubleshooting

The helm chart only provides proper notes for the most common cases. See 
[![](images/ico/color/helm_16.png)![](images/ico/github_16.png) NOTES.txt](https://github.com/helm/charts/blob/master/stable/grafana/templates/NOTES.txt)
which is responsible for a prpoper usage message. The maintainers of the chart not having updated the usage notes properly.

1) When a secret is provided the installer should omit the password

```bash
kubectl get secret --namespace grafana grafana-creds -o jsonpath="{.data.GF_SECURITY_ADMIN_PASSWORD}" | base64 --decode ; echo
```


export POD_NAME=$(kubectl get pods --namespace grafana -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
