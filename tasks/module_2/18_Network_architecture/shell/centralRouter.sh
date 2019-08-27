#!/bin/bash

yum install -y traceroute

echo 'net.ipv4.conf.all.forwarding=1' >> /etc/sysctl.conf
echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0 
echo "GATEWAY=192.168.255.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
echo '192.168.2.0/24 via 192.168.254.2' > /etc/sysconfig/network-scripts/route-eth2
echo '192.168.1.0/24 via 192.168.253.2' > /etc/sysconfig/network-scripts/route-eth3

reboot