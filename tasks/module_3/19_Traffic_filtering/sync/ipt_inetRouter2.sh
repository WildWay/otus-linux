#!/bin/bash
EXT_IF=eth?              # Имя внешнего интерфейса
EXT_IP="xxx.xxx.xxx.xxx" # IP адрес внешнего интерфейса

INT_IF=eth?              # Имя внутреннего интерфейса
INT_IP="xxx.xxx.xxx.xxx" # IP адрес внутреннего интерфейса

FAKE_PORT=$1             # Порт внешнего интерфейса
LAN_IP=$2                # IP адрес сервера
SRV_PORT=$3              # Порт сервера

iptables -t nat -A PREROUTING -d $EXT_IP -p tcp -m tcp --dport $FAKE_PORT -j DNAT --to-destination $LAN_IP:$SRV_PORT
iptables -t nat -A POSTROUTING -d $LAN_IP -p tcp -m tcp --dport $SRV_PORT -j SNAT --to-source $INT_IP
iptables -t nat -A OUTPUT -d $EXT_IP -p tcp -m tcp --dport $SRV_PORT -j DNAT --to-destination $LAN_IP
iptables -I FORWARD 1 -i $EXT_IF -o $INT_IF -d $LAN_IP -p tcp -m tcp --dport $SRV_PORT -j ACCEPT