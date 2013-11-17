# Configuration examples 

## Minimum Viable Firewall / Router for home use

Assumptions:

- eth0 = connected to internet
- eth1 = connected to home network
- The Firewall itself can access the internet
- Firewall management is only allowed from the home network (ssh)

This firewall permits any out-going internet connections originating from either the firewall or the home network. 

```sh

nat $eth1_net $eth0
allow_forward "$eth1_net" any any any

allow_in $eth1_net $eth1 any "$SSH"
allow_out $eth0 any any any
	
```

## Home network with restrictions on outbound traffic

- eth0 = connected to internet
- eth1 = connected to home network
- The home network only is allowed to access the most basic services:
   - HTTP(S)
   - DNS
   - NTP
   - DHCP 
- The Firewall itself has the same restrictions for outbound traffic
- Firewall management is only allowed from the home network (ssh)
- Only web-based email is supported (no SMTP/POP/IMAP)

```sh

WEB="
    80/tcp
    443/tcp
"

DNS="
    53/udp
    53/tcp
"

NTP="123/udp"

SSH="22/tcp"

DHCP="
    67/udp
    68/udp
"

BASIC_SERVICES="
	$WEB
	$DNS
	$NTP
"

nat $eth1_net $eth0
allow_forward "$eth1_net" any any "$BASIC_SERVICES"

allow_in $eth1_net $eth1 any "$SSH"
allow_in any $eth1 "$DHCP" "$DHCP"

allow_out $eth0 any any "$BASIC_SERVICES"
allow_out $eth1_net $eth1 "$DHCP" "$DHCP"

```


## Network with extra services NAT and port-forwarding

In this scenario, the firewall is a DNS-server, NTP-server, PROXY-server and DHCP-server.

```sh
ENABLE_SYSLOG=1

#
# Brute-force protection for SSH service
#
DENY_SSH_BF=1
DENY_SSH_BF_IP="$eth0"
DENY_SSH_BF_PORT=22

WEBSERVER=192.168.0.20

PROXY="3128/tcp"

WEB="
    80/tcp
    443/tcp
"

SSH="22/tcp"

INTERNET_ACCESSIBLE_SERVICES="
    $WEB
    $SSH
"

DNS="
    53/udp
    53/tcp
"

NTP="123/udp"

DHCP="
    67/udp
    68/udp
"

MAIL="
  25/tcp
  2525/tcp
  110/tcp
  995/tcp
  143/tcp
  993/tcp
  587/tcp
  465/tcp
"

LAN_SERVICES="
    $DNS
    $NTP
    $SSH
    $PROXY
"

BASIC_SERVICES="
    $WEB
    $MAIL  
"

FIREWALL_OUTBOUND="
	$DNS
	$NTP
	$WEB
"



#
# Services accessible from the internal network
#
allow_in $eth1_net $eth1 any "$LAN_SERVICES"

#
# Required if you run DHCP
#
allow_in any $eth1 any "$DHCP"
allow_out $eth1 any "$DHCP" "$DHCP"

#
# Allow the router/firewall to initiate connections to services on the Internet.
#
allow_out $eth0 any any "$FIREWALL_OUTBOUND" 

#
# Basic NAT for the internal network connected to eth1. 
#
nat $eth1_net $eth0

#
# Just NAT is not enough, it must be permitted to forward data.
#
allow_forward "$eth1_net" any any "$BASIC_SERVICES"

#
# If you only want users to access the internet through the proxy
# you should remove '$WEB' from '$BASIC_SERVICES'
#
# Use WPAD through DNS for automatic client proxy configuration
#

#
# Portforward port 80 on the internet interface towards the internal webserver
#
port_forward "$eth0" "$WEBSERVER" 80/tcp

#
# If you run a server in your local LAN and it get's hacked, your entire network
# is then compromised! Consider setting up a DMZ for internet-accessible services.
#

#
# If the web service is listening on port 8080 on the webserver, you need to
# redirect the port as well:
#
port_forward "$eth0" "$WEBSERVER" 80/tcp 8080/tcp

```

## Firewall with LAN and DMZ

The firewall is connected to the internet and two separate networks. These networks can either be physical networks or VLANs.

In this scenario we want to setup a webserver within the DMZ. If it gets hacked, an attacker cannot attack / access the LAN.

The webserver can access some services on the internet for DNS, NTP, updates, etc.

- Only the IT person can access the firewall.
- No services running on the firewall are exposed to the web server. This would allow a possible point of entry for an attacker. 
- Ideally, you would have a separate DNS, NTP and update server within the DMZ, hardened as much as possible and the only system within the DMZ to be permitted to initiate outbound connections to the Internet.
- eth0 = connected to internet
- eth1 = connected to LAN
- eth2 = connected to DMZ

```sh

WEBSERVER=192.168.100.10

BOFHSTATION=192.168.1.50

WEB="
    80/tcp
    443/tcp
"

DNS="
    53/udp
    53/tcp
"

NTP="123/udp"

SSH="22/tcp"

DHCP="
    67/udp
    68/udp
"

BASIC_SERVICES="
	$WEB
	$DNS
	$NTP
"

nat $eth1_net $eth0
allow_forward "$eth1_net" any any "$BASIC_SERVICES"

allow_in "$BOFHSTATION" $eth1 any "$SSH"
allow_in any $eth1 "$DHCP" "$DHCP"

allow_out $eth0 any any "$BASIC_SERVICES"
allow_out $eth1_net $eth1 "$DHCP" "$DHCP"

#
# We permit the webserver to acces some services on the internet for operation.
# Since the webserver only has a non-routable IP-address, NAT is required.
# 
nat $eth2_net $eth0
allow_forward "$eth2_net" any any "$BASIC_SERVICES"

#
# This rule permits the internet to access the webserver
#
port_forward "$eth0" "$WEBSERVER" 80/tcp

```






