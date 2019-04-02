#!/usr/bin/env bash

# Задача 1. Написать сервис:
#     - раз в 30 секунд_проверяет_лог на наличие ключевого слова
#     -_лог и_слово_должны задаваться в_/etc/sysconfig/


# Создать скрипт watchlog
echo '#!/usr/bin/env bash

WORD=$1
LOG=$2
DATE=`date`

if grep $WORD $LOG &> /dev/null
then
    logger "$DATE: I found word, Master!"
else
    exit 0
fi
' > /opt/watchlog.sh

# Добавить права на исполнение скрипту watchlog
chmod +x /opt/watchlog.sh

# Создать лог, для успешной отработки сервиса на примере
echo '
just a string
another one
ALERT
and another ALERT
may be one more STRING
and another "ALERT" message in a string
' > /var/log/watchlog.log

# Создать конфиг для watchlog
echo '# CONFIG FILE FOR /opt/watchlog.sh
WORD="ALERT"
LOG="/var/log/watchlog.log"
' > /etc/sysconfig/watchlog

# Создать unit для сервиса
echo '
[Unit]
Description=My watchlog service

[Service]
Type=oneshot
StartLimitBurst=0
EnvironmentFile=/etc/sysconfig/watchlog
ExecStart=/opt/watchlog.sh $WORD $LOG
' > /usr/lib/systemd/system/watchlog.service

# Создать unit для таймера
echo '
[Unit]
Description=Run watchlog script every 2 second

[Timer]
OnBootSec=1
OnUnitActiveSec=2
AccuracySec=1us
Unit=watchlog.service

[Install]
WantedBy=multi-user.target
' > /usr/lib/systemd/system/watchlog.timer

# Запустить таймер
systemctl start watchlog.timer

sleep 5

# Записать результат задачи 1 в result.txt
echo "Задача 1. Результат выполнения:" | tee ~/result.txt
grep "Master!" /var/log/messages | tee -a >> ~/result.txt


# =================================================================


# Задача 2. Создать сервис из spawn-fcgi:
#     - установить spawn-fcgi из epel
#     - переписать init-скрипт на unit-файл
#     - имя сервиса должно называться также

# Установить spawn-fcgi и необходимые, для него, пакеты
yum install -y epel-release
yum install -y spawn-fcgi php php-cli mod_fcgi httpd

# Раскоментировать параметры SOCKET и OPTIONS
sed -i "s/#SOCKET/SOCKET/" /etc/sysconfig/spawn-fcgi
sed -i "s/#OPTIONS/OPTIONS/" /etc/sysconfig/spawn-fcgi

# Создать unit
echo '
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target

[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n $OPTIONS
KillMode=process

[Install]
WantedBy=multi-user.target
' > /etc/systemd/system/spawn-fcgi.service

# Включить и запустить сервис, записать результат в файл result.txt
systemctl enable --now spawn-fcgi
echo -e "\nЗадача 2. Результат выполнения:" | tee -a ~/result.txt
systemctl status spawn-fcgi | tee -a ~/result.txt


# =================================================================


# Задача 3. Дополнить юнит-файл apache httpd:
#     - возможность запустить несколько инстансов
#     - с разными конфигами

# Добавить возможность запуска нескольких экземпляров httpd
cp /usr/lib/systemd/system/httpd.service /usr/lib/systemd/system/httpd@.service
sed -i "s/EnvironmentFile=\/etc\/sysconfig\/httpd/EnvironmentFile=\/etc\/sysconfig\/httpd-%I/" /usr/lib/systemd/system/httpd@.service

# Создать 2 конфигурационных файла для каждого из экземпляров
cat /etc/httpd/conf/httpd.conf | tee /etc/httpd/conf/{first,second}.conf &>/dev/null

# Изменить порт и PidFile для второго экземпляра
sed -i "s/Listen 80/Listen 8080\nPidFile \/var\/run\/httpd-second.pid/" /etc/httpd/conf/second.conf

# Создать 2 файла окружения для каждого из экземпляров
cat /etc/sysconfig/httpd | tee /etc/sysconfig/httpd-{first,second} &>/dev/null

# Скорректировать используемые конфигурационные файлы
sed -i "s/#OPTIONS=/OPTIONS=-f conf\/first.conf/" /etc/sysconfig/httpd-first
sed -i "s/#OPTIONS=/OPTIONS=-f conf\/second.conf/" /etc/sysconfig/httpd-second

# Запустить оба экземпляра
systemctl start httpd@first
systemctl start httpd@second

# Убедиться что оба экземпляра запущены и записать результат в result.txt
echo -e "\nЗадача 3. Результат выполнения:" | tee -a ~/result.txt
ss -tnulp | grep httpd | tee -a ~/result.txt


# =================================================================


# Ждать 5 секунд, перед выводом результатов
sleep 5

# Очистить экран и вывести результат выполнения задач
echo "============================================================"
clear

cat ~/result.txt