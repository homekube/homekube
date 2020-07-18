# Simple echo service

Following the instructions of [![](images/ico/color/homekube_16.png) Helm Basics](helm-basics.md) 
we have already created a simple 'Who-am-i' service. 
From the verification steps we know how to 
[![](images/ico/color/homekube_16.png) preview a helm installation](helm-basics.md#verify).
Now lets check whats actually created in our `whoami` namespace:

```bash
kubectl get all -n whoami
```
```text
NAME                          READY   STATUS    RESTARTS   AGE
pod/whoami-7b6ff5b56d-wwjh6   1/1     Running   0          19h

NAME             TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/whoami   ClusterIP   10.152.183.217   <none>        80/TCP    19h

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/whoami   1/1     1            1           19h

NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/whoami-7b6ff5b56d   1         1         1       19h
```

Compared with the installation chart we see an additional Pod and a Replicaset. Those were created
by the Deployment. The replicaset watches the number of instances specified in the deployment
and adjusts the number of pod instances to match the specified `spec.replicas`. Now lets 
increase this number and see what happens. Open **another terminal** session and watch 
the replicaset so we can see the changes happen:
```bash
kubectl get rs -n whoami --watch
```

and in our terminal we increase the number of replicas:

```bash
kubectl scale --replicas=5 deployment.apps/whoami -n whoami
```

While executing the `kubectl scale` command you see the changes in the montoring terminal one by one:
```text
NAME                DESIRED   CURRENT   READY   AGE
whoami-7b6ff5b56d   1         1         1       20h
whoami-7b6ff5b56d   5         1         1       20h
whoami-7b6ff5b56d   5         1         1       20h
whoami-7b6ff5b56d   5         5         1       20h
whoami-7b6ff5b56d   5         5         2       20h
whoami-7b6ff5b56d   5         5         3       20h
whoami-7b6ff5b56d   5         5         4       20h
whoami-7b6ff5b56d   5         5         5       20h
```

Now we have 5 replicas started and repeating `kubectl get all -n whoami` shows the result:
```text
NAME                          READY   STATUS    RESTARTS   AGE
pod/whoami-7b6ff5b56d-2czbq   1/1     Running   0          2m52s
pod/whoami-7b6ff5b56d-2f8pm   1/1     Running   0          2m53s
pod/whoami-7b6ff5b56d-lxdtp   1/1     Running   0          2m52s
pod/whoami-7b6ff5b56d-rxjn9   1/1     Running   0          2m52s
pod/whoami-7b6ff5b56d-wwjh6   1/1     Running   0          20h

NAME             TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/whoami   ClusterIP   10.152.183.217   <none>        80/TCP    20h

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/whoami   5/5     5            5           20h

NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/whoami-7b6ff5b56d   5         5         5       20h
```

Lets verify that all these pods are actually used to serve requests. After changing
the service type to `NodePort` we will be able to query the service directly - 
in contrast of querying a single pod - thats what happens when using the `kubectl port-forward ...` command.

```bash
kubectl patch svc whoami -p '{"spec": {"type": "NodePort"}}' -n whoami
kubectl get svc -n whoami
```
```text
NAME     TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
whoami   NodePort   10.152.183.88   <none>        80:32175/TCP   46m
```

We take the assigned NodePort `32175` from the response and execute in a terminal:
```bash
while true; do curl -X GET '192.168.1.100:32175'; sleep 0.5; done
```
```text
...
Hostname: whoami-7b6ff5b56d-vqznp
IP: 127.0.0.1
IP: ::1
IP: 10.1.88.63
IP: fe80::c09c:deff:fe34:ae31
RemoteAddr: 10.1.88.1:34336
GET / HTTP/1.1
Host: 192.168.1.100:32175
User-Agent: curl/7.58.0
Accept: */*

Hostname: whoami-7b6ff5b56d-jcl2c
IP: 127.0.0.1
IP: ::1
IP: 10.1.88.62
IP: fe80::ac6b:4ff:fe89:5d4e
RemoteAddr: 10.1.88.1:34372
GET / HTTP/1.1
Host: 192.168.1.100:32175
User-Agent: curl/7.58.0
Accept: */*

Hostname: whoami-7b6ff5b56d-h85jq
IP: 127.0.0.1
IP: ::1
IP: 10.1.88.64
IP: fe80::9477:51ff:fe64:cee5
RemoteAddr: 10.1.88.1:34392
GET / HTTP/1.1
Host: 192.168.1.100:32175
User-Agent: curl/7.58.0
Accept: */*

Hostname: whoami-7b6ff5b56d-jcl2c
IP: 127.0.0.1
IP: ::1
IP: 10.1.88.62
IP: fe80::ac6b:4ff:fe89:5d4e
RemoteAddr: 10.1.88.1:34438
GET / HTTP/1.1
Host: 192.168.1.100:32175
User-Agent: curl/7.58.0
Accept: */*
...
```
Now we have the proof that the serving pod changes as indicated
by the varying IP-addresses in the response. The service will
forward incoming requests in a round-robin manner to its pods.

## Public service
For public exposure on 
[![](images/ico/color/homekube_link_16.png) https://whoami.homekube.org](https://whoami.homekube.org)
there is an Ingress created:

```bash
cd ~/homekube/src/whoami
kubectl apply -f ingress-whoami.yaml
```
Now visting the webpage and repeatedly refreshing its contents we will see the responses of the varying pods.
You will also be able to test it locally when using the Igress' LoadBalancers IP (should be 192.168.1.200) e.g.
```
curl -kX GET 'https://192.168.1.200' -H 'host: whoami.homekube.org'
```
