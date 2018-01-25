# Project VPN gateway

## Purpose

The project is aimed at creating a VPN gateway that supports:

* IKEv2
* Routing between internal networks and VPC
* Road warrior IPSec clients, including mobile devices, and NAT for them

Additionally, by designing, developing and maintaining the project, it is
hoped:

* To create integrated development environments (local virtual environment,
  staging environment for pre-release, and production environment)
* To provide unified test framework (sharing same tests with environments,
  creating specific test cases to an environment)
* To create a generic template for other projects
* To find out common use cases in projects during developing
* To implement common operational interfaces for maintainers

## Rationales

Transparent proxy, discussed later, is the enemy of all system administrators.
Without deep analysis, you cannot tell if there is one between you and the
other end. It makes the life of the system administrators even more painful.
VPN creates overheads but it is acceptable and justifiable.

Some service providers restrict access from foreign countries mainly due to
copyrights or legal issues. In other cases, they show different contents to
users from foreign countries, or even deny access because non-residents are
not the targeted customers. In one case, a hosting company drops L4 packets
NOT from _their intended IP addresses_ thanks to huge amount of malicious
traffics from a country, effectively denying customers to access machines they
have paid for.

Thailand is one of ASEAN countries where oppression and censorship are
ubiquitous. Peering with foreign operators used to be monopolized. Now,
private companies are allowed and the market has been opened, but the
operators are under constant pressure from the junta government, calling for
creating [Single Gateway](https://en.wikipedia.org/wiki/Internet_in_Thailand#Single_Internet_gateway).
Also, the country has been known for the strictest lese majeste law. Even
under democratically elected governments, it is illegal to access to some
_sensitive_ information. Minimum sentence is seven years in prison, multiplied
by number of incidents, which means clicking _share_ button on three
_sensitive_ articles on SNS leads to 21 years in prison. You may cut the term
into half by pleading guilty, but still you will be behind bars for more than
a decade. Because of usual economical reasons and the pressures, the ISPs have
implemented [transparent HTTP proxies](https://en.wikipedia.org/wiki/Proxy_server#Transparent_proxy), which
give network administrators enough pains as discussed earlier. Unlike Beijing,
the junta is not very confident at its legitimacy and popularity. Tracking
plain text protocols, blocking sites based on IP address (they have blocked
BBC, Daily Mail, and other news sites) and restricting international peering
are all what they can do at the moment.  Other strict restrictions, such as L3
blocking, [DNS spoofing](https://en.wikipedia.org/wiki/DNS_spoofing), and TLS
[MITM](https://en.wikipedia.org/wiki/Man-in-the-middle_attack), have not been
implemented. Increased usage of TLS is also raising the bar.  Furthermore,
Thailand national is one of the heaviest SNS users, or the penetration rate of
facebook alone is more than 70% of the population, a source says. The SNS
addiction has prevented the proposed Single Gateway plans. All in all, the
censorship in Thailand is more relaxed than elsewhere and it will be so in the
foreseeable future in my opinion. That being said, in addition to practical
reasons above as a system administrator, I hate being monitored, especially
where _the rule of law_ is not in dictionary.

## Design

The OS for the gateway is FreeBSD. Initially, OpenBSD was chosen but its
`iked(8)` still lacks some interoperability. As the project must support
various IKEv2 clients and flexibility to support multiple authentication
methods, it was decided to wait for further improvements in the future.  On
the other hand, FreeBSD also its own drawbacks. `ipfw(8)` does not support
failover, the syntax, or the lack of it, of security policies is hard to
maintain, atomic change to security policy is not possible, and, sadly,
`pf(4)` is derived from ancient one. This unfortunate choice also implies
various networking daemons, except some lucky ones, from OpenBSD will not be
available. Hopefully, `iked(8)`, which has been actively developed at the time
of this writing, will be mature for the next release.

IKEv2 daemon for choice is `strongswan`. It supports multiple platforms,
excluding OpenBSD, multiple EAP methods, and provides client applications for
mobile devices. It does not support IKEv1, but there are not many reasons to
support the protocol. Although IKEv2 support from vendors is less than ideal,
MS and Apple officially support IKEv2.

## Implementations

### Road warrior IPSec clients

Implemented. The following table shows platforms that have been confirmed.

| Platform | IKE client | Notes |
|----------|------------|-------|
| Android 8.0.0 | `strongswan` 5.5.3 | MOBIKE just works but other applications hangs after handover, possibly sending packets to wrong route |
| FreeBSD 11.1 | `strongswan` 5.6.0 | |

### Routing

Not yet implemented.

## Operations

See [README_PROJECT](README_PROJECT.md).
