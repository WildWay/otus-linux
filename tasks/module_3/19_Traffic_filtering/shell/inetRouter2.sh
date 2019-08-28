#!/bin/bash

yum install -y traceroute iptables-services
systemctl enable --now iptables.service

echo -e 'net.ipv4.conf.all.forwarding=1' >> /etc/sysctl.conf
echo '192.168.255.0/30 via 192.168.254.2
192.168.250.0/28 via 192.168.254.2
' > /etc/sysconfig/network-scripts/route-eth1

iptables --flush && iptables --flush -t nat
iptables -t nat -A PREROUTING -d 192.168.0.10 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 192.168.250.2:80
iptables -t nat -A POSTROUTING -d 192.168.250.2 -p tcp -m tcp --dport 80 -j SNAT --to-source 192.168.254.1
iptables -t nat -A OUTPUT -d 192.168.0.10 -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.250.2
iptables -I FORWARD 1 -i eth2 -o eth1 -d 192.168.250.2 -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -s 192.168.250.0/28 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -s 192.168.254.0/30 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -s 192.168.255.0/30 -j MASQUERADE
iptables -A FORWARD -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -j REJECT

iptables-save > /etc/sysconfig/iptables

reboot