# Cert Manager

In this step we will install [![](images/ico/color/kubernetes_16.png) Cert Manager](https://cert-manager.io/docs/).   

We might skip this because it is not strictly required in the first place.
The downside is that while browsing our application the browser will respond with warnings about 'Untrusted - your website is not secure'. 

Benefits are: 

* Obtaining LetsEncrypt certificates
* Provision of a wildcard certificate for homekube.org and all of its subdomains
* Automated certificate renewal

Cert-Manager Kubernetes provides an integrated open source solution that does this (and much).
The common term for the method we use is **ACME/DNS01** provider where ACME stands for **'Automated Certificate Management Environment** and 
**DNS01** is the method by which LetsEncrypt validates ownership of a requested validation for a wildcard domain. 
[![](images/ico/book_16.png) Read more about Letsencrypt challenges and the DN01 challenge type](https://letsencrypt.org/docs/challenge-types/#dns-01-challenge)


## Installation

Following the [![](images/ico/color/kubernetes_16.png) Cert-Manager installation](https://cert-manager.io/docs/installation/kubernetes/) instructions:    

```bash
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.1/cert-manager.yaml
```

Its recommended to [![](images/ico/color/kubernetes_16.png) verify the installation](https://cert-manager.io/docs/installation/kubernetes/#verifying-the-installation) .

## Configuration

Read the background [![](images/ico/instructor_16.png) to understand the principles of operation](cert-manager-long.md) 

While Cert-Manager cares about automation renewal and integration of the certificates on the kubernetes level 
its not able to communicate with LetsEncyrypt services directly. Instead it delegates this task to its 
[![](images/ico/color/kubernetes_16.png) ACMEDNS adapter](https://cert-manager.io/docs/configuration/acme/dns01/acme-dns/)
which in turn makes use of another helper service. [![](images/ico/github_16.png) Acme-dns](https://github.com/joohoi/acme-dns#acme-dns)
is a basic DNS server that acts on behalf of your providers DNS service for the sole purpose of renewing LetsEncrypt certificates.

### ACME-DNS

The author of Acme-dns recommends you install your own helper service (official terminology [![](images/ico/book_16.png) CertBot client](https://certbot.eff.org/)) 
which can be done following the [![](images/ico/github_16.png) usage instructions](https://github.com/joohoi/acme-dns#usage).

While its generally advisable to be in control of this component we will take the short-path here and use a public service
located at ``https://auth.acme-dns.io``

> NOTE: You need to be aware that this component is cruicial for automated updates and we have to trust the provider for confidentiality. 
 In case the provider terminates its services or he loses your registration data then the automated renewal gets terminated 

#### Registration

Open a local terminal and register:
```bash
curl -s -X POST https://auth.acme-dns.io/register | python -m json.tool
```

A random response will be generated. We will use this data for the configuration of the automated update process
Response Example:
```json
{
    "allowfrom": [],
    "fulldomain": "84bba6b0-b446-42ff-8d22-11b27f4ff717.auth.acme-dns.io",
    "password": "mPSNztp-s_m2atJtT8wapPQ7Z4AIIyE4i5H7fQas",
    "subdomain": "84bba6b0-b446-42ff-8d22-11b27f4ff717",
    "username": "81bbffed-f46c-43e5-997e-777e8ab1298f"
}
```

#### Update

We will use the response for configuration. First we need to update our DNS providers CNAME settings.
In common bind notation we'd define
```bash
_acme-challenge.homekube.org   IN CNAME	84bba6b0-b446-42ff-8d22-11b27f4ff717.auth.acme-dns.io.
```
> NOTE: As a CNAME value you have to copy the "fulldomain" property value **terminated by a dot .** !

Usually you have to use your dns providers console or webinterface for that. 
Homekube's DNS host is [Artfiles.de](https://artfiles.de) and a 
[screenshot of the dns webinterface modifications](images/artfiles_dns_webui.png) is provided as a reference. 

> Note again the **trailing dot .**  ! 

Next we'll check in a local terminal if configuration was successful
```bash
dig _acme-challenge.homekube.org
```

The response will contain a line like

```
;; ANSWER SECTION:
_acme-challenge.homekube.org. 599 IN	CNAME	84bba6b0-b446-42ff-8d22-11b27f4ff717.auth.acme-dns.io.
```

[ ![](images/ico/color/youtube_16.png) ![](images/ico/terminal_16.png)4:15 Acme-Dns manual update demo](https://asciinema.org/a/94903)

Next we follow the 
[![](images/ico/color/kubernetes_16.png) ACME-DNS cofiguration instructions](https://cert-manager.io/docs/configuration/acme/dns01/acme-dns/)
and save the registration response into a .json file ``acme-dns.json`` on the server with the domain name as a key and the response as its value:

```json
{ "homekube.org": 
  {
    "allowfrom": [],
    "fulldomain": "84bba6b0-b446-42ff-8d22-11b27f4ff717.auth.acme-dns.io",
    "password": "mPSNztp-s_m2atJtT8wapPQ7Z4AIIyE4i5H7fQas",
    "subdomain": "84bba6b0-b446-42ff-8d22-11b27f4ff717",
    "username": "81bbffed-f46c-43e5-997e-777e8ab1298f"
  }
}
```

As a last step we create a kubernetes secrets containing the credentials needed for the automated update:

```bash
kubectl create secret generic homekube-acme-dns -n cert-manager --from-file acmedns.json
```
