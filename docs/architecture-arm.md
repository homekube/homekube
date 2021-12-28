# Installation on arm64

On arm64 hardware (e.g. [![](images/ico/color/raspi_20.png) Raspberry4](https://www.raspberrypi.org/)) containers need to be built for this architecture. 
This is the case for all official images on dockerhub which are multi-platform by default meaning they
run on 
[![](images/ico/book_16.png) ![](images/ico/color/docker_16.png) any architecture supported by Docker](https://www.docker.com/blog/docker-official-images-now-multi-platform/).  
All apps in this tutorial are tested to work on arm64 architectures with a few exceptions that need specific containers. 
For most helm charts its just a matter of 'googling' to find a proper replacement and provide a parameter for that specific image.

## Nfs client

The current helm install supports arm64 architecture

## Prometheus

The current helm install supports arm64 architecture
