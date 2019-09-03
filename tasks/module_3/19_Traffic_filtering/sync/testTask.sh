#!/bin/bash

testTask(){
    echo
    echo "Поставленные задачи:"
    echo "  1. centralRouter может попасть на ssh inetrRouter через knock скрипт"
    echo "  2. inetRouter2 доступ по public IP"
    echo "  3. nginx установлен на centralServer и запущен на порту 80"
    echo "  4. Веб-сервер centralServer:80 проброшен на public IP inetRouter2:8080"
    echo "  5. Доступ в интернет через inetRouter"
    echo "======================================="

    echo
    echo "Для проверки задачи 1 необходимо запустить knock.sh с centralRouter"
    echo "С других машин работать не будет (обусловлено задачей)"
    echo "Команда проверки:"
    echo "/vagrant/knock.sh 192.168.255.1 12345 23456 34567 60438 vagrant"
    echo "Пароль - vagrant"

    echo
    echo "Для проверки задачи 2 необходимо одно из двух:"
    echo "1. Прописать доп адрес на каком-либо интерфейсе из сети 192.168.0.0/24"
    echo "   Либо свой, если в nodes.yml для inetRouter2 устанавливался IP из своей сети"
    echo "2. Осуществить ping на этот IP"
    echo "   Команда проверки:"
    echo "   ping 192.168.0.10"

    echo
    echo "Для проверки задач 3 и 4 можно использовать одну команду:"
    echo "curl 192.168.0.10:8080"
    echo "Либо подставить свой IP" 

    echo "Для проверки задачи 5 можно использовать скрипт:"
    echo "/vagrant/5task.sh"
}