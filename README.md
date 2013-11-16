# Eztables: simple yet powerful firewall configuration for Linux

Eztables allows you to quickly configure a firewall without ever touching iptables. The firewall rule syntax is designed to be easy to read and to apply.  

This is how you allow the entire internet to access your webserver on tcp-port 80:

```sh
	allow_in any $eth0 any 80/tcp
``` 

Eztables is designed to be simple, yet powerful. It doesn't matter if you want to protect your laptop, are setting up a home router, or use it to setup a corporate firewall. 

# Features

* Basic input / output filtering
* Network address translation (NAT)
* Port address translation (PAT)
* Support for VLANs
* Working with Groups / Objects to aggregate hosts and services
* Logging to syslog
* Support for plugins
* Automatically detects all network interfaces

# Why should I consider using Eztables?

Eztables has it's own firewall rule syntax that is significantly simpler than using iptables directly. A tool like [UFW][https://help.ubuntu.com/community/UFW] was made with a similar mindset, but it is more host-centric. It was never designed to be used as a general-purpose firewall script.

Ezfirwall on the other hand, can be used on any Linux bos, wether it's a desktop, server or network firewall. 
 
Ezfirewall has support for advanced features like NAT and port-forwarding. But one of the most powerfull features is support for object groups, as found in most commercial firewalls and routers. Object groups are cool because they allow you to group hosts in 'objects' and refer to those objects in your rules. This allows you to keep the number of firewall rules relatively small and comprehensible.

# Example: basic network 

With these two configuration lines, you can setup a functional home router. 

```sh
    nat $eth1_net $eth0
    allow_forward $eth1_net any any any
```

That's easy right? It's just two lines because Eztables can detect all network interfaces also determine which one is connected to the internet (eth0).

This rule will allow SSH access to this router/firewall.

```sh
    allow_in $eth1_net $eth1 any 22/tcp
```

Note that SSH access is only granted from within the local network connected to the eth1 interface..

If you also run a DHCP-server on this box, you need to allow clients acces with these rules:

```sh
	allow_in any $eth1 any $DHCP" "$DHCP"
	allow_out "$eth1" any "$DHCP" "$DHCP"
```

The "$DHCP" variable should look like this:

```sh
	DHCP="
	    67/udp
	    68/udp
	"
```

You may have to setup additional rules if you run a local DNS server or a [proxy server][http://louwrentius.com/setting-up-a-squid-proxy-with-clamav-anti-virus-using-c-icap.html]

## Working with object groups

A main advantage of Eztables over other solutions is the possibility to define and use groups or objects. This is a feature commonly found on all commercial firewall products. 

Working with object groups allows you to keep your firewall ruleset small and simple. Let's take a look at the use of objects and groups.

```sh
    HTTP_SERVICES="
        80/tcp
       443/tcp
    "

    WEB_SERVER_1=192.168.0.10
    WEB_SERVER_2=192.168.0.20
    WEB_SERVER_3=192.168.0.30

    WEB_SERVERS="
        $WEB_SERVER_1
        $WEB_SERVER_2
        $WEB_SERVER_3
    "

    allow_in any "$WEB_SERVERS" any "$HTTP_SERVICES"
```

So object groups allow you to define firewall rules in a more abstract form, which is easy to maintain and to expand upon.

You can even nest objects. For example, you can define an object $BASIC_SERVICES that contains the objects $DNS $HTTP_SERVICES and $NTP. 

## Installation

Run the install.sh file like:

    bash install.sh

After that, review the configuration file: /etc/eztables/eztables.cfg

Start the firewall like this:

    /etc/init.d/eztables start

Be carefull not to lock yourself out if you test your rules.

    /etc/init.d/eztables start && sleep 30 && /etc/init.d/eztables stop

## Roadmap

- Traffic shaping plugin
- IPv6 support
- Support for multi-homed networks
- See the issue section for more 