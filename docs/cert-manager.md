# Cert Manager

In this step we will install [![](images/ico/color/kubernetes_16.png) Cert Manager](https://cert-manager.io/docs/).   

>**NOTE:** Before you proceed you need a domain that you own. In this tutorial we use 'homekube.org'

We might skip this because it is not strictly required in the first place.
The downside is that while browsing our application the browser will respond with warnings about 'Untrusted - your website is not secure'. 

Benefits are: 

* Obtaining LetsEncrypt certificates
* Provision of a wildcard certificate for a domain and all of its subdomains
* Automated certificate renewal

Cert-Manager Kubernetes provides an integrated open source solution that does this (and much more).
The common term for the method we use is **ACME/DNS01** provider where ACME stands for **'Automated Certificate Management Environment** and 
**DNS01** is the method by which LetsEncrypt validates ownership of a requested validation for a wildcard domain. 
[![](images/ico/book_16.png) Read more about Letsencrypt challenges and the DNS01 challenge type](https://letsencrypt.org/docs/challenge-types/#dns-01-challenge)

## Preparation

Create a cert-manager working directory on your server and cd into that:
```bash
cd ~/homekube/src/cert-manager
```

## Installation

Following the [![](images/ico/color/kubernetes_16.png) Cert-Manager installation](https://cert-manager.io/docs/installation/kubernetes/) instructions:    

```bash
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.1/cert-manager.yaml
```

Its recommended to [![](images/ico/color/kubernetes_16.png) verify the installation](https://cert-manager.io/docs/installation/kubernetes/#verifying-the-installation) .

## Configuration of Helpers

While Cert-Manager cares about automated renewal and integration of the certificates on the kubernetes level 
its not able to communicate with LetsEncyrypt services directly. Instead it delegates this task to its 
[![](images/ico/color/kubernetes_16.png) ACMEDNS adapter](https://cert-manager.io/docs/configuration/acme/dns01/acme-dns/)
which in turn makes use of another helper service. [![](images/ico/github_16.png) Acme-dns](https://github.com/joohoi/acme-dns#acme-dns)
is a basic DNS server that acts on behalf of your providers DNS service for the sole purpose of renewing LetsEncrypt certificates.

[![](images/ico/color/homekube_16.png) Learn more about the principles of operation](cert-manager-long.md) 

### ACME-DNS

The author of Acme-dns recommends you install your own helper service (official terminology 
[![](images/ico/book_16.png) CertBot client](https://certbot.eff.org/)) 
which can be done following the [![](images/ico/github_16.png) usage instructions](https://github.com/joohoi/acme-dns#usage).

While its generally advisable to be in control of this component we will take the short-path here and use a public service
located at ``https://auth.acme-dns.io``

> NOTE: You need to be aware that this component is cruicial for automated updates and we have to trust the provider for confidentiality. 
 In case the provider terminates its services or he loses your registration data then the automated renewal gets terminated and needs to be reconfigured

Service usage is a 2 step process.
First we will register at the service manually and its response data is then used for automated updating.
   
#### Registration

Next we will register at the service manually:
```bash
curl -s -X POST https://auth.acme-dns.io/register | python -m json.tool

# if you get an error message: Command 'python' not found
# you can install it with 'sudo apt install python-minimal'
```

A random response will be generated. Example:
```json
{
    "allowfrom": [],
    "fulldomain": "84bba6b0-b446-42ff-8d22-11b27f4ff717.auth.acme-dns.io",
    "password": "mPSNztp-s_m2atJtT8wapPQ7Z4AIIyE4i5H7fQas",
    "subdomain": "84bba6b0-b446-42ff-8d22-11b27f4ff717",
    "username": "81bbffed-f46c-43e5-997e-777e8ab1298f"
}
```
#### Updating

We will use the response as input for configuration. First we need to update our DNS providers CNAME settings
with the **fulldomain** value of the response. ``_acme-challenge.yourdomain.tld`` is the key required by LetsEncrypt.
In common bind notation we'd define
```bash
_acme-challenge.homekube.org   IN CNAME	84bba6b0-b446-42ff-8d22-11b27f4ff717.auth.acme-dns.io.
```
> NOTE: As a CNAME value you have to copy the "fulldomain" property value **terminated by a dot .** !

Usually you have to use your dns providers console or webinterface for that. 
Homekube's DNS host is [Artfiles.de](https://artfiles.de) and a 
[screenshot of the dns webinterface modifications](images/artfiles_dns_webui.png) is provided as a reference. 

> Note again the **trailing dot .**  ! 

Next we'll check (a google nameserver) if configuration was successful
```bash
dig @8.8.8.8 _acme-challenge.homekube.org
```

The response will contain a line like

```
;; ANSWER SECTION:
_acme-challenge.homekube.org. 599 IN	CNAME	84bba6b0-b446-42ff-8d22-11b27f4ff717.auth.acme-dns.io.
```

[![](images/ico/color/youtube_16.png) ![](images/ico/terminal_16.png) 4:15 Acme-Dns manual update demo](https://asciinema.org/a/94903)

Next we follow the 
[![](images/ico/color/kubernetes_16.png) ACME-DNS configuration instructions](https://cert-manager.io/docs/configuration/acme/dns01/acme-dns/)
and save the registration response into a **.json** file **`acme-dns-homekube.json`** on the server in your current directory 
with the **domain name as a key** and the **response as its value**.   
Replace ``homekube.org`` with a domain name of your choice.
**Example** looks like:

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

## Configuration Cert-Manager

Now that we have the helpers in place we need a last step to complete the installation
* Create a secret from the previously saved registration response
* Create a Certficate template that will be signed
* by an Issuer to be defined

Lets create our own namespace first to prevent cluttering the default namespace and edit a local copy 
of `homekube-staging.yaml` and `homekube-prod.yaml` to replace the occurrences of `homekube.org` and `homekube`
with the name of your top-level domain.
 
```bash
kubectl create secret generic acme-dns-homekube -n cert-manager --from-file acme-dns-homekube.json
kubectl apply -f homekube-staging.yaml
```

Lets verify our installation 

```bash
kubectl describe secret homekube-tls-staging -n cert-manager-homekube
```
should evaluate to 
```
Name:         homekube-tls-staging
...
Type:  kubernetes.io/tls

Data
====
ca.crt:   0 bytes
tls.crt:  3562 bytes
tls.key:  1679 bytes
```

The important part here is that both **tls.crt** and **tls.key** must be present and not empty.
In case of errors follow the [![](images/ico/color/kubernetes_16.png) troubleshooting section](https://cert-manager.io/docs/faq/acme/).
Note that you need to append all commands with ` -n cert-manager-acme-secrets` as thats the namespace that we use
for secrets, certificates, issuers, ... .

If everything goes well we can obtain the 'real' certficate form LetsEncrypt production endpoint. LetsEncrypt has quite
[![](images/ico/book_16.png) restricitve rate-limits](https://letsencrypt.org/docs/rate-limits/) about the usage
of its production endpoint so you better double-check with the staging-endpoint.

The production manifest are the same as staging except that:
* the acme server endpoint `https://acme-staging-v02.api.letsencrypt.org/directory`   
is replaced by `https://acme-v02.api.letsencrypt.org/directory`
* all other occurrences of ``staging`` are replace by ``prod``

```bash
kubectl apply -f homekube-prod.json
```

When the resulting secret 
```bash
kubectl describe secret homekube-tls-prod -n cert-manager-homekube
```
contains a non-empty **tls.crt** and **tls.key** you are done

