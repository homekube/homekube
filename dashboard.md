# Dashboard

The MicroK8s docs contain a brief chapter on how to [![](images/ico/color/ubuntu_16.png) set up the dashboard](https://microk8s.io/docs/addon-dashboard). 
While its a good excercise to just follow these steps and already learn a bit about terminology and components it feels a bit clumsy for a novice user.
From an educational point of view i think its preferrable to start with something simple first and then dive deeper.

```bash
microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443 --address 0.0.0.0
``` 

This is a test link to a [temporary dashboard](https://dashboard.oops.de)