#!/bin/bash

yum install -y traceroute epel-release
yum install -y nginx
systemctl enable --now nginx

echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0 
echo "GATEWAY=192.168.250.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1

reboot