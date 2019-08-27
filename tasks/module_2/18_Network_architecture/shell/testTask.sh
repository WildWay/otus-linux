#!/bin/bash

echo -e "\nПроверка выполнения задач:"
echo "1. Соединить офисы в сеть согласно схеме и настроить роутинг"
echo "   Все серверы должны видеть друг друга"
echo "2. Все серверы и роутеры должны ходить в инет черз inetRouter"
echo "   У всех новых серверов отключить дефолт на нат (eth0), который вагрант поднимает для связи"

echo -e "\n\nПроверка доступности интерфейсов с каждой машины\n"
cat /vagrant/ip_list | awk '{system("ping " $2 " -c 1 &>/dev/null; \
if [[ $? == 0 ]]; \
then echo PING OK " $1 " " $2 "; \
else echo PING FAIL " $1 " " $2 "; \
fi")}'

echo -e "\n\nПроверка таблицы маршрутизации, доступа на внешку и первые 4 маршрутизатора\n"
echo "`ip route`

`ping 8.8.8.8 -c 1 | grep time`

`traceroute 8.8.8.8 -m 4`
"
