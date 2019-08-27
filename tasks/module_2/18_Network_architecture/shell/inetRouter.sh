#!/bin/bash

yum install -y traceroute iptables-services
systemctl enable --now iptables.service

echo -e 'net.ipv4.conf.all.forwarding=1' >> /etc/sysctl.conf
echo '192.168.0.0/25 via 192.168.255.2
192.168.1.0/24 via 192.168.255.2
192.168.2.0/24 via 192.168.255.2
192.168.253.0/30 via 192.168.255.2
192.168.254.0/30 via 192.168.255.2
' > /etc/sysconfig/network-scripts/route-eth1

iptables --flush && iptables --flush -t nat
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -s 192.168.0.0/25 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -s 192.168.1.0/24 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -s 192.168.2.0/24 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -s 192.168.253.0/30 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -s 192.168.254.0/30 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -s 192.168.255.0/30 -j MASQUERADE
iptables -A FORWARD -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -j REJECT

iptables-save > /etc/sysconfig/iptables

reboot