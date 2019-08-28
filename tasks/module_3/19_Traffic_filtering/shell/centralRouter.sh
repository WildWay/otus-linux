#!/bin/bash

yum install -y traceroute

echo 'net.ipv4.conf.all.forwarding=1' >> /etc/sysctl.conf
echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0 
echo "GATEWAY=192.168.255.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
echo '192.168.0.0/24 via 192.168.254.1' > /etc/sysconfig/network-scripts/route-eth2

reboot