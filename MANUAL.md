# Eztables Manual

## Minimum required TCP/UDP services

Most if not all computers need the following service to operate:

- DNS (tcp/udp port 53)
- NTP (udp port 123) (Time synchronisation)
- HTTP(S) (tcp port 80 / 443)

## Overview of all commands

- allow_in
- allow_out
- deny_in
- deny_out
- allow_forward
- deny_forward
- port_forward
- nat
- allow_icmp

![overview](http://louwrentius.com/static/images/eztables-rules.png)

## Debugging firewall rules

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

## Work in progres...
