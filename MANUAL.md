# Eztables Manual

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

## Port Forwarding

The first example just forwards incoming traffic on the internet-facing firewall interface (port 80) to the same port on the web server. If you omit the destination port, the to-be-forwarded port is used as the destination port. But the second example shows how to map traffic from the external port 80 to the internal port 8080 on the web server.

    port_forward "$FW_EXT" "$WWW_SERVER" 80

    port_forward "$FW_EXT" "$WWW_SERVER" 80 8080

## Work in progres...
