# Configuration examples 

## Home network with port-forwarding and NAT
```sh
ENABLE_SYSLOG=1

#
# Brute-force protection for SSH service
#
DENY_SSH_BF=1
DENY_SSH_BF_IP="$eth0"
DENY_SSH_BF_PORT=22

WEBSERVER=192.168.0.20

PROXY="

    3128/tcp
"

WEB="

    80/tcp
    443/tcp
"

SSH="

    22/tcp
"

INTERNET_ACCESSIBLE_SERVICES="

    $WEB
    $SSH
"

DNS="

    53/udp
    53/tcp
"

NTP="

    123/udp
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

BASIC_SERVICES="

    $WEB
    $DNS
    $NTP
    $SSH
    $PROXY
    $MAIL
    $IRC
"
#
# Allow connections to the SSH services from within the local network.
#
allow_in $eth1_net $eth1 any "$SSH"

#
# required if this router/firewall runs DNS/NTP/HTTP/etc
#
allow_in $eth1_net $eth1 any "$BASIC_SERVICES" 

#
# Allow the router/firewall to initiate connections to services on the Internet.
#
allow_out $eth0 any any "$BASIC_SERVICES" 

#
# Basic NAT for the internal network connected to eth1. 
#
nat $eth1_net $eth0

#
# Just NAT is not enough, it must be permitted to forward data.
#
allow_forward "$eth1" any any "$BASIC_SERVICES"

#
# Portforward port 80 on the internet interface towards the internal webserver
#
port_forward "$eth0" "$WEBSERVER" 80/tcp

#
# If the web service is listening on port 8080 on the webserver, you need to
# redirect the port as well:
#
port_forward "$eth0" "$WEBSERVER" 80/tcp 8080/tcp
```
