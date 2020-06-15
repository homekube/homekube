# Cert Manager operating principles

Before we proceed with configuration its useful to understand the [![](images/ico/book_16.png) basic principles of operation](https://letsencrypt.org/how-it-works/). 
LetsEncrypt needs to verify the ownership of the domain before it issues a certificate and in the process of validation it will request a modification of the domain that can only be fulfilled by the legitimate domain owner. 
This modification request is called a 'challenge' that has to be solved. There are different procedures for [![](images/ico/book_16.png) the different challenge types](https://letsencrypt.org/docs/challenge-types/) 
and we will choose here **DNS01** challenge here because its the only one that allows domain certification with wildcard domains.

The [![](images/ico/book_16.png) **DNS01** challenge](https://letsencrypt.org/docs/challenge-types/#dns-01-challenge) is applied at the level of your DNS provider. 
The [![](images/ico/book_16.png) TXT section of DNS](https://www.cloudflare.com/learning/dns/dns-records/dns-txt-record/) must be modified by the domain owner to fulfill the challenge 
presented by LetsEncrypt. This challenge will be renewed periodically and so we want an automated process to do that. 
There is a [![](images/ico/book_16.png) list of providers](https://community.letsencrypt.org/t/dns-providers-who-easily-integrate-with-lets-encrypt-dns-validation/86438) 
that allow for an easy integration with LetsEncrypt validation but basically it should work with any provider. 
However automated validation requires 
your DNS provider to offer an API for modifying the requested challenges programmatically. 
Not all providers do so and even if they do its often not desirable
to use their API for LetsEncrypt validation. 
With these keys usually you can steal a domain easily and its a serious security consideration to leave these keys 
possibly at different locations (in case of multiple top level domains) to some third party tool for a possible manipulation of all the domains you own.

The solution to this is to create a [![](images/ico/book_16.png) less privileged **CNAME** subdomain](https://www.cloudflare.com/learning/dns/dns-records/dns-cname-record/) 
which acts as a placeholder and allows only to perform the requested challenge for automated LetsEnrypt validation. 
This is more secure as it needs only a manual one time modification of the DNS settings at your provider. 
It can be done manually with the ui your dns provider offers and allows for a provider independent automated renewal process
without exposing any provider specific secrets.

While Cert-Manager cares about automation renewal and integration of the certificates on the kubernetes level 
its not able to communicate with LetsEncyrypt services directly. Instead it delegates this task to its 
[![](images/ico/color/kubernetes_16.png) ACMEDNS adapter](https://cert-manager.io/docs/configuration/acme/dns01/acme-dns/)
which in turn makes use of another helper service. [![](images/ico/github_16.png) Acme-dns](https://github.com/joohoi/acme-dns#acme-dns)
is a basic DNS server that acts on behalf of your providers DNS service for the sole purpose of renewing LetsEncrypt certificates.
