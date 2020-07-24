# Installation on arm64

On arm64 hardware (e.g. [![](images/ico/color/raspi_16.png) Raspberry4](https://www.raspberrypi.org/)) containers need to be built for this architecture. 
This is the case for all official images on dockerhub which are multi-platform by default meaning they
run on 
[![](images/ico/book_16.png) ![](images/ico/color/docker_16.png) any architecture supported by Docker](https://www.docker.com/blog/docker-official-images-now-multi-platform/).  
All apps in this tutorial are tested to work on arm64 architectures with a few exceptions that need specific containers. 
For most helm charts its just a matter of 'googling' to find a proper replacement and provide a parameter for that specific image.

## Nfs client

The nfs client needs an additional parameter to load an image build for arm64 only:

```bash
helm install nfs-client --version=1.2.8 \
--set storageClass.name=managed-nfs-storage --set storageClass.defaultClass=true \
--set nfs.server=<Your-nfs-server-ip>--set nfs.path=<your-nfs-server-path> \
--set image.repository=quay.io/external_storage/nfs-client-provisioner-arm \
--namespace nfs-storage \
stable/nfs-client-provisioner
```

## Prometheus

Prometheus loads a couple of images and one of them, the `kube-state-metrics` is not built for arm64.
We fix this by providing the image and version.

```bash
helm install prometheus -n prometheus --version=11.6.1 \
--set alertmanager.enabled=false \
--set pushgateway.enabled=false \
--set server.persistentVolume.storageClass=managed-nfs-storage \
--set kube-state-metrics.image.repository=carlosedp/kube-state-metrics \
--set kube-state-metrics.image.tag=v1.9.6 \
stable/prometheus
```
