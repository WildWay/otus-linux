#!/usr/bin/env bash

# Проверить доступность машин
ping 192.168.11.250 -c 1 &>/dev/null && ping 192.168.11.251 -c 1 &>/dev/null && ping 192.168.11.252 -c 1 &>/dev/null
if [[ $? != 0  ]]; then
    echo "===== Одна из машин стенда не доступна."
    echo "===== Продолжение."
    exit
fi

echo "===== Информация для проверки =============="

echo "============================================"
echo "Запрос статуса elastic stack у elk-MASTER"
curl -XGET 'elk-master:9200/_cluster/health?pretty' 2>/dev/null
echo "============================================"

echo "============================================"
echo "Запрос статуса elastic stack у elk-DATA"
curl -XGET 'elk-data:9200/_cluster/health?pretty'   2>/dev/null
echo "============================================"

echo "============================================"
echo "Доступ к elasticsearch:"
echo "http://192.168.11.250:5601"
echo "========="
echo "Доступ к loganalyzer:"
echo "http://192.168.11.250/loganalyzer"
echo "Логин: admin ___ Пароль: Password"
echo "========="
echo "Доступ к веб-серверу nginx:"
echo "http://192.168.11.252"
echo "============================================"