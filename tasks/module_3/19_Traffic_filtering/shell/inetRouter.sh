#!/bin/bash

yum install -y traceroute iptables-services
systemctl enable --now iptables.service

sed -i "65s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sed -i "s/#Port 22/Port 60438/"                                     /etc/ssh/sshd_config
echo   "Protocol 2"                                              >> /etc/ssh/sshd_config
echo   "PermitRootLogin no"                                      >> /etc/ssh/sshd_config

echo 'net.ipv4.conf.all.forwarding=1'                            >> /etc/sysctl.conf

echo '192.168.254.0/30 via 192.168.255.2
192.168.250.0/28 via 192.168.255.2
192.168.0.0/24 via 192.168.255.2'                                 > /etc/sysconfig/network-scripts/route-eth1


iptables -F && iptables -F -t nat && iptables -X && iptables -Z

iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -s 192.168.250.0/28 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -s 192.168.254.0/30 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -s 192.168.255.0/30 -j MASQUERADE
iptables -A FORWARD -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -j REJECT


# Фильтрация и PORT KNOCKING
# Кратко суть:
#   1. То, что вне правил - отбрасывается
#   2. TCP соединение можно установить:
#        - после трех последовательных стуков по udp
#        - на определённый порт (изменённый порт ssh)
#        - с определённого адреса (centralRouter)

iptables -N STATE0
iptables -A STATE0 -p udp --dport 12345 -m recent --name KNOCK1 --set -j REJECT
iptables -A STATE0 -j REJECT

iptables -N STATE1
iptables -A STATE1 -m recent --name KNOCK1 --remove
iptables -A STATE1 -p udp --dport 23456 -m recent --name KNOCK2 --set -j REJECT
iptables -A STATE1 -j STATE0

iptables -N STATE2
iptables -A STATE2 -m recent --name KNOCK2 --remove
iptables -A STATE2 -p udp --dport 34567 -m recent --name KNOCK3 --set -j REJECT
iptables -A STATE2 -j STATE0

iptables -N STATE3
iptables -A STATE3 -m recent --name KNOCK3 --remove
iptables -A STATE3 -p tcp --dport 60438 --source 192.168.255.2 -j ACCEPT
iptables -A STATE3 -j STATE0

itpables -A INPUT -m state --state INVALID -j DROP
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT

iptables -A INPUT -m recent --name KNOCK3 --rcheck -j STATE3
iptables -A INPUT -m recent --name KNOCK2 --rcheck -j STATE2
iptables -A INPUT -m recent --name KNOCK1 --rcheck -j STATE1
iptables -A INPUT -j STATE0


iptables-save > /etc/sysconfig/iptables

reboot