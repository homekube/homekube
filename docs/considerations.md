# Considerations before getting started

There are so many options but which way is the best for you ?
All of these options assume that you have a basic knowledge of Linux.
While its not a strict requirement it might flatten your learning curve considerably. 

#### Start with one of the big cloud providers

[Amazon EKS](https://aws.amazon.com/de/eks/) - 
[Azure AKS](https://azure.microsoft.com/de-de/services/kubernetes-service) -
[Google Cloud](https://cloud.google.com/kubernetes-engine)
to name a few. This may be tempting as it relieves you from going through the steps of setting up the basic environment.
Additionally most if not all providers offer sort of free trials for starters. 
The downside is that once the free period expires you'll get monthly bills from your provider.
How much will they charge ? Well thats hard to say in advance. Because it largely depends on what you are going to do.
Are you just going to host 'Hello World - my private site for fun and education' ?
Or are you going to host the next Google Maps ? Obviously this will make a big $$$ difference. 

#### A local installation from the sources

If you want to understand Kubernetes at a deeper level and you don't mind spending the time for investigation then these educational videos
[Kubernetes the hard way - ![](../images/ico/color/youtube_16.png) ![](../images/ico/terminal_16.png) Part 1](https://www.youtube.com/watch?v=NvQY5tuxALY) 
and [![](../images/ico/color/youtube_16.png) ![](../images/ico/terminal_16.png) Part 2](https://www.youtube.com/watch?v=2bVK-e-GuYI) might be for you.
The author Venkat is a mastermind of [professional educational ![](../images/ico/color/youtube_16.png) tutorials on **OpenSource**](https://www.youtube.com/user/wenkatn).
He will go through the nitty-gritty details of Kelsey Hightowers [![](../images/ico/github_16.png) Kubernetes the hard way](https://github.com/kelseyhightower/kubernetes-the-hard-way) recipe of setting up a complete installation from zero.
Kelsey is a google cloud advocate and as a conference speaker he is well-known for his entertaining talks.

#### A local installation with opinionated settings

There are a couple of opinionated other installation options, you can [read more about them here](https://www.reddit.com/r/kubernetes/comments/be0415/k3s_minikube_or_microk8s).
They have all different pros and cons but the main reasons for picking Canonicals [Microk8s](https://microk8s.io/) are simplicity and its 'Linux by nature' character.
No VMs required (which would add another layer [of complexity]) the only requirement is to have a Linux box with Ubuntu installed.
Requirements from the [![](../images/ico/color/ubuntu_16.png) **Microk8s docs**](https://microk8s.io/docs):

* An **Ubuntu 20.04 LTS** or Ubuntu 18.04 LTS or 16.04 LTS environment to run the commands
(or another operating system which supports snapd - see the snapd documentation)
* At least 20G of disk space and 4G of memory are recommended
* An internet connection
