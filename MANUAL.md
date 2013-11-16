# Eztables Manual

## Basic syntax for configuration 

This is the basic syntax for every firewall rule:

```sh
    allow_in <source host(s)> <destination host(s)> <source port(s)> <destination port(s)>
```

![overview](http://louwrentius.com/static/images/eztables-rules.png)

There are also additiional commands such as allow_out, deny_in and deny_out. See the manual for more detailed instructions.

## Design 

Eztables does not allow any communication between the networks it is connected to. However, if you want to allow a host to access the internet, you need to permit access to 'any' IP-address, which would include the other local networks. 

This is why Eztables on startup detects all networks and generates explicit 'default deny' rules that prevent these networks from talking to each other. These default deny rules take precedence over any rule that permit access from or to any host.

This is why there are two major CHAINS or rulesets: LOOSE_RULES and STRICT_RULES. Loose rules always contain an 'any' as the source or destination'. These rules are only processed AFTER the default deny rules for security reasons. 

Strict rules are more specific and those rules can be used to allow traffic between hosts in different local networks. These rules are processed before the default deny rules.

Understanding this design may help you to debug more elaborate firewall configurations.

## Minimum required TCP/UDP services

When setting up firewall rules, it's important to keep in mind that these services are almost always needed:

- DHCP (tcp/udp port 67/68)
- DNS (tcp/udp port 53)
- NTP (udp port 123) (Time sync)
- HTTP(S) (tcp port 80 / 443)

See the [examples.md][https://github.com/louwrentius/eztables/blob/master/EXAMPLES.md] file 

## Overview of all commands

- allow_in
- allow_out
- deny_in
- deny_out
- allow_forward
- deny_forward
- port_forward (special syntax)
- nat (special syntax)
- allow_icmp (special syntax)

## Debugging firewall rules

To debug issues you may have to read the active iptables configuration (unfortunately).

If debugging is enabled, all firewall rules are echoed back to the screen. To enable debug mode:

```
    /etc/init.d/eztables start debug
```

You can also use this variable:

```sh
    export eztables_DEBUG=1
```

You can further debug firewall configuration issues with iptables itself. The -v option of iptables shows which rules are 'hit' by traffic.

```
   iptables -v -n -L
   iptables -v -n -L -t nat
```

To prevent yourself from locking yourself out, test your firewall like this:

```
    /etc/init.d/eztables start && sleep 30 && /etc/init.d/eztables stop
```

## Network address translation (NAT)

Setting up NAT is trivial. If you just want to allow some computers in a network to access the internet, you don't need to specify the 'interface' option. 
Eztables detects the internet interface automatically and if the interface is ommitted, it is assumed that this interface must be used.

NAT can be used between any network, and in that case, the correct interface must be specified.

    nat <network to NAT> <ip of interface> <interface>

A NAT rule by itself is not sufficient. By default - due to security reasons - Ezfirewall disables communication between networks.
A forwarding rule must be configured in order to enable internet access. 

    allow_forward "$eth1_net" any any "$WEB"

## Port Forwarding

The first example just forwards incoming traffic on the internet-facing firewall interface (port 80) to the same port on the web server. If you omit the destination port, the to-be-forwarded port is used as the destination port. But the second example shows how to map traffic from the external port 80 to the internal port 8080 on the web server.

    port_forward "$FW_EXT" "$WWW_SERVER" 80

    port_forward "$FW_EXT" "$WWW_SERVER" 80 8080

## Object groups

