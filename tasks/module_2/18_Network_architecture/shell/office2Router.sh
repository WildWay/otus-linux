#!/bin/bash

yum install -y traceroute

echo 'net.ipv4.conf.all.forwarding=1' >> /etc/sysctl.conf
echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0 
echo "GATEWAY=192.168.253.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1

reboot