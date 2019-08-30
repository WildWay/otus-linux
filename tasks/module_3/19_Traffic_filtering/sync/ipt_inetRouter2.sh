#!/bin/bash
EXT_IF=eth?              # Имя внешнего интерфейса
EXT_IP="xxx.xxx.xxx.xxx" # IP адрес внешнего интерфейса

INT_IF=eth?              # Имя внутреннего интерфейса
INT_IP="xxx.xxx.xxx.xxx" # IP адрес внутреннего интерфейса

EXT_PORT=$1              # Порт внешнего интерфейса
SRV_IP=$2                # IP адрес сервера
SRV_PORT=$3              # Порт сервера

iptables -t nat -A PREROUTING -d $EXT_IP -p tcp -m tcp --dport $EXT_PORT -j DNAT --to-destination $SRV_IP:$SRV_PORT
iptables -t nat -A POSTROUTING -d $SRV_IP -p tcp -m tcp --dport $SRV_PORT -j SNAT --to-source $INT_IP
iptables -t nat -A OUTPUT -d $EXT_IP -p tcp -m tcp --dport $SRV_PORT -j DNAT --to-destination $SRV_IP
iptables -I FORWARD 1 -i $EXT_IF -o $INT_IF -d $SRV_IP -p tcp -m tcp --dport $SRV_PORT -j ACCEPT