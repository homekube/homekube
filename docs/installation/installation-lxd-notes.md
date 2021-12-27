
[Kubectl exec Kube does not exist](https://stackoverflow.com/questions/51154911/kubectl-exec-results-in-error-unable-to-upgrade-connection-pod-does-not-exi)  
[**Kubelet quirks** / Kubeadm](https://medium.com/@joatmon08/playing-with-kubeadm-in-vagrant-machines-part-2-bac431095706)  

[**Default Ubuntu MicroK8s profile**](https://github.com/ubuntu/microk8s/blob/master/tests/lxc/microk8s.profile)  
[**How to make your LXD containers get IP addresses from your LAN using macvlan**](https://blog.simos.info/how-to-make-your-lxd-container-get-ip-addresses-from-your-lan/)  
[**Options for HA master topology**](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/)  

# Overlay network

![](images/3rd-party/overlay-network-illustration.png)

In the context of Kubernetes, an overlay network allows Pods in a Kubernetes cluster to communicate over multiple clusters in a separate IP range to the underlying VPC.

In the following example, we can see how overlay networks are implemented through the use of a popular CNI called Flannel. Assume the Pod Web App Frontend 1 which is located in Node1 wants to talk to the pod Backend Service 2 which is located in Node2.

Web App Frontend 1 creates an IP packet with source: 10.1.15.2 -> destination: 10.1.20.3. This packet will leave the virtual adapter (veth0) which is attached to that pod and go to the docker0 bridge. Docker0 will then consult it’s route table, where it sees that all endpoints outside of 10.1.15.0/24 sit on other hosts, and forwards it to the flannel0 endpoint accordingly.

The flannel0 bridge works with the flanneld process to manage a mapping of hosts to network zones in the Kubernetes KV Store, ETCD. In this case, it knows that 10.1.20.3 sits in on the host 192.168.0.200 and will wrap the packet in another packet with source: 192.168.0.100 -> destination 192.168.0.200.

The packet will then travel out through the VPC network to the destination host and hit the destinations flanneld. From there, it reverses the process above and travels to the destination pod.

[Credits original post](https://www.contino.io/insights/kubernetes-is-hard-why-eks-makes-it-easier-for-network-and-security-architects)


# Drain node

```bash
kubectl drain <node-name> --ignore-daemonsets --delete-local-data
kubectl delete node <node-name>
kubeadm reset
```

