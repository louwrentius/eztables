# eztables is easy firewalling

Eztables allows you to define iptables firewall rules that are easy to understand and simple to manage. It uses iptables so you don't have to.

Eztables is designed to be simple, yet powerful. It does not matter if you are setting up a home router, or use it to setup a corporate firewall. Eztables supports:

* Basic input / output filtering
* Network address translation (NAT)
* Port address translation 
* Service and host groups
* Logging to syslog
* Support for plugins
* Automatically detects all network interfaces

## Example: home network 

With these two configuration lines, we will setup a working home router. 

```
    nat $eth1_net $eth0
    allow_forward $eth1_net any any any
```

That's easy right? It can be just two lines because Eztables can detect all interfaces and which one is used for internet access.

This rule will allow SSH access to this router/firewall.

```
    allow_in $eth1_net $eth1 any 22/tcp
```

Note that SSH access is only granted from within the local network.

## Using groups for hosts and services

A main advantage of Eztables over other solutions is the possibility to define and use groups or objects. This is a feature commonly found
on all commercial firewall products. 

Working with objects and groups allows you to keep your firewall ruleset small and simple. Let's take a look at the use of objects and groups.

```
    HTTP_SERVICES="
        80/tcp
       443/tcp
    "

    WEB_SERVER_1=192.168.0.10
    WEB_SERVER_2=192.168.0.11

    WEB_SERVERS="
        $WEB_SERVER_1
        $WEB_SERVER_2
    "

    allow_in any "$WEB_SERVERS" any "$HTTP_SERVICES"
```

If hosts or services are added to the appropriate group, the number of firewall rules will still be the same. Actually, that's not entirely
true: the ezfirewall configuration stays the same, only under the hood will eztables create the appropriate iptables rules.

## Basic syntax for configuration 

This is the basic syntax for every firewall rule:

```
    allow_in <source host(s)> <destination host(s)> <source port(s)> <destination port(s)>
```

There are also additiional commands such as allow_out, deny_in and deny_out. See the manual for more detailed instructions.
