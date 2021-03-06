#!/usr/bin/env bash
mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh
sed -i '65s/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

yum install -y vim bacula-client
/bin/cp -f /vagrant/bacula-fd.conf /etc/bacula/

echo "============================================"
echo "Имя хоста - `hostname`"
echo "IP адрес для подключения - `hostname -I | cut -d ' ' -f 2`"
echo "============================================"